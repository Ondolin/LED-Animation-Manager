use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::{BoxedLayer, Layer, Rgb, STRIP_SIZE};

#[derive(Serialize, Deserialize, Debug)]
pub struct Color {
    uuid: Uuid,
    #[serde(skip)]
    leds: Vec<Rgb>,
    value: Rgb,
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

#[typetag::serde]
impl Layer for Color {
    fn initialize(&mut self, _previous_layers: &[BoxedLayer]) {
        self.leds = vec![self.value; *STRIP_SIZE];
    }

    fn update(&mut self, _previous_layers: &[BoxedLayer]) {
        self.leds = vec![self.value; *STRIP_SIZE];
    }

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

    fn uuid(&self) -> Uuid {
        self.uuid
    }
}
