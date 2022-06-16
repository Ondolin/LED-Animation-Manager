use std::time::{Duration, SystemTime};

use crate::{Layer, Rgb, STRIP_SIZE, Animation};

use serde::{Deserialize, Serialize};

use uuid::Uuid;

#[derive(Serialize, Deserialize, Debug, PartialEq, animation_macro::AnimationTraits)]
pub struct Timer {
    uuid: Uuid,
    start_time: SystemTime,
    target_time: Duration,
    color: Rgb,
    #[serde(skip)]
    leds: Vec<Rgb>,
}

impl Timer {
    pub fn new(duration: Duration, color: Rgb) -> Timer {
        Timer {
            uuid: Uuid::new_v4(),
            leds: Vec::new(),
            start_time: SystemTime::now(),
            target_time: duration,
            color
        }
    }
}

impl Layer for Timer {
    fn initialize(&mut self, _previous_layers: &[Animation]) {
        self.leds = vec![Rgb::new(0, 0, 0); *STRIP_SIZE];
    }

    fn update(&mut self, previous_layers: &[Animation]) {

        let percentage_past = 1.0 - (self.start_time.elapsed().unwrap().as_millis() as f32 / self.target_time.as_millis() as f32);

        if percentage_past < 0.0 {
            return;
        }

        let last_active_led = (*STRIP_SIZE as f32 * percentage_past) as usize;

        let previous = previous_layers[previous_layers.len() - 1].to_led_values();

        for i in 0..*STRIP_SIZE {
            if i < last_active_led {
                self.leds[i] = self.color;
            } else {
                self.leds[i] = previous[i];
            }
        } 
    }

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

}
