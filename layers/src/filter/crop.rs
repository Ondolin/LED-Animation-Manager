use serde::{Serialize, Deserialize};
use uuid::Uuid;

use crate::{Rgb, Layer, BoxedLayer, STRIP_SIZE};

#[derive(Serialize, Deserialize, Debug)]
pub struct Crop {
    uuid: Uuid,
    left: usize,
    right: usize,
    #[serde(skip)]
    leds: Vec<Rgb>
}

impl Crop {
    pub fn new(left: usize, right: usize) -> Crop {

        Crop { 
            uuid: Uuid::new_v4(),
            left,
            right,
            leds: Vec::new()
        }
    }
}

#[typetag::serde]
impl Layer for Crop {

    fn initialize(&mut self, previous_layers: &[BoxedLayer]) {

        self.leds = vec![Rgb::new(0, 0, 0); *STRIP_SIZE];

        if self.left as usize > *STRIP_SIZE {
            log::info!("Left value for crop is to big!");
        } else if self.right as usize > *STRIP_SIZE {
            log::info!("Right value for crop is to big!");
        } else if self.left > self.right {
            log::info!("Left value of crop is grater than right value!");
        } else if previous_layers.len() < 3 {
            log::info!("Not enough layers!");
        }
    }

    fn update(&mut self, previous_layers: &[BoxedLayer]) {

        let amount_layers = previous_layers.len();
        let strip_size: usize = *STRIP_SIZE;

        let parital_hidden_level = previous_layers[amount_layers - 1].to_led_values();
        let alpha_level = previous_layers[amount_layers - 2].to_led_values();

        let mut leds: Vec<Rgb> = Vec::new();

        leds.extend_from_slice(&alpha_level[0..self.left]);
        leds.extend_from_slice(&parital_hidden_level[self.left..self.right]);
        leds.extend_from_slice(&alpha_level[self.right..strip_size]);

        self.leds = leds;

    }

    fn to_led_values(&self) -> &Vec<Rgb> {
        &self.leds
    }

    fn uuid(&self) -> Uuid {
        self.uuid
    }
}
