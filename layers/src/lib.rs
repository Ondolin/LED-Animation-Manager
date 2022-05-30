use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct Layer {}

impl Layer {
    pub fn initialize(&mut self, _previous_layers: Vec<Layer>) {}
    pub fn update(&mut self, _previous_layers: Vec<Layer>) {}
    pub fn delete(self, _previous_layers: Vec<Layer>) {}
}
