use serde::{Serialize, Deserialize};
use uuid::Uuid;

use crate::{Rgb, Layer, BoxedLayer, STRIP_SIZE};

#[derive(Serialize, Deserialize, Debug)]
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

#[typetag::serde]
impl Layer for NoAnimation {

    fn initialize(&mut self, _previous_layers: &[BoxedLayer]) {
        self.leds = vec![Rgb::new(0, 0, 0); *STRIP_SIZE];
    }

    fn update(&mut self, _previous_layers: &[BoxedLayer]) {}

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

    fn uuid(&self) -> Uuid {
        self.uuid
    }
}
