use layers::Animation;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct StripLayers {
    pub layers: Vec<Animation>,
}

impl StripLayers {
    pub fn new() -> Self {
        Self { layers: Vec::new() }
    }

    pub fn push_layer(&mut self, layer: Animation) {
        self.layers.push(layer);
    }
}
