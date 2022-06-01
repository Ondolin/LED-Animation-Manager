use serde::{Deserialize, Serialize};

use layers::BoxedLayer;

#[derive(Serialize, Deserialize, Debug)]
pub struct StripLayers {
    pub layers: Vec<BoxedLayer>,
}

impl StripLayers {
    pub fn new() -> Self {
        Self { layers: Vec::new() }
    }

    pub fn push_layer(&mut self, layer: BoxedLayer) {
        self.layers.push(layer);
    }
}
