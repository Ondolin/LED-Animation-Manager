use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::{Layer, Rgb, STRIP_SIZE, Animation};

#[derive(Serialize, Deserialize, Debug, animation_macro::AnimationTraits)]
pub struct Color {
    uuid: Uuid,
    #[serde(skip)]
    leds: Vec<Rgb>,
    value: Rgb,
}

impl PartialEq<Color> for Color {
    fn eq(&self, other: &Color) -> bool {
        self.uuid == other.uuid && self.value == other.value
    }
}

impl Color {
    pub fn new(color: Rgb) -> Color {
        Color {
            uuid: Uuid::new_v4(),
            leds: Default::default(),
            value: color,
        }
    }

    pub fn new_with_uuid(color: Rgb, uuid: Uuid) -> Self {
        Self { 
            uuid,
            leds: Default::default(),
            value: color
        }
    }
}

impl Layer for Color {
    fn initialize(&mut self, _previous_layers: &[Animation]) {
        self.leds = vec![self.value; *STRIP_SIZE];
    }

    fn update(&mut self, _previous_layers: &[Animation]) {}

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

}
