use crate::{Layer, Rgb, STRIP_SIZE, Animation};

use prisma::{FromColor, Hsv};
use serde::{Deserialize, Serialize};

use angular_units::Deg;
use uuid::Uuid;

#[derive(Serialize, Deserialize, Debug, PartialEq, animation_macro::AnimationTraits)]
pub struct RainbowWheel {
    uuid: Uuid,
    step_size: Deg<f32>,
    #[serde(skip)]
    leds: Vec<Rgb>,
    #[serde(skip)]
    current_color: Hsv<f32, Deg<f32>>,
}

impl RainbowWheel {
    pub fn new(step_size: Deg<f32>) -> Self {
        Self {
            uuid: Uuid::new_v4(),
            leds: Vec::new(),
            step_size,
            current_color: Hsv::new(Deg(0.0), 1.0, 1.0),
        }
    }
}

impl Layer for RainbowWheel {
    fn initialize(&mut self, _previous_layers: &[Animation]) {
        self.leds = vec![Rgb::new(0, 0, 0); *STRIP_SIZE];
        self.current_color = Hsv::new(Deg(0.0), 1.0, 1.0)
    }

    fn update(&mut self, _previous_layers: &[Animation]) {
        *self.current_color.hue_mut() += self.step_size;
        *self.current_color.hue_mut() %= Deg(360.0);

        let mut value = self.current_color;

        for i in 0..*STRIP_SIZE {
            let rgb: Rgb = prisma::Rgb::from_color(&value).color_cast();

            self.leds[i] = rgb;

            *value.hue_mut() += self.step_size;
            *value.hue_mut() %= Deg(360.0);
        }
    }

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

}
