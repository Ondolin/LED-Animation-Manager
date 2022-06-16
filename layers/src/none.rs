use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::{Layer, Rgb, STRIP_SIZE, Animation};

#[derive(Serialize, Deserialize, Debug, PartialEq, animation_macro::AnimationTraits)]
pub struct NoAnimation {
    uuid: Uuid,
    #[serde(skip)]
    leds: Vec<Rgb>,
}

impl NoAnimation {
    pub fn new() -> NoAnimation {
        NoAnimation {
            uuid: Uuid::new_v4(),
            leds: Default::default(),
        }
    }
}

impl Layer for NoAnimation {
    fn initialize(&mut self, _previous_layers: &[Animation]) {
        self.leds = vec![Rgb::new(0, 0, 0); *STRIP_SIZE];
    }

    fn update(&mut self, _previous_layers: &[Animation]) {}

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

}
