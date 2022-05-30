use std::sync::Mutex;

use serde::{Serialize, Deserialize};

use layers::Layer;

#[derive(Serialize, Deserialize, Debug)]
pub struct StripLayers {
    layers: Vec<Layer>
}

impl StripLayers {
    pub fn new() -> Self {
        Self {
            layers: Vec::new()
        }
    }
}

lazy_static! {
    pub static ref CURRENT_STATE: Mutex<StripLayers> = Mutex::new(StripLayers::new());
}
