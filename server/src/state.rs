use std::sync::Mutex;

use serde::{Deserialize, Serialize};

use layers::BoxedLayer;

#[derive(Serialize, Deserialize)]
pub struct StripLayers {
    pub layers: Vec<BoxedLayer>
}

impl StripLayers {
    pub fn new() -> Self {
        Self { layers: Vec::new() }
    }
}

lazy_static! {
    pub static ref CURRENT_STATE: Mutex<StripLayers> = Mutex::new(StripLayers::new());
}
