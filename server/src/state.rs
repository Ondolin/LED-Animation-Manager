use std::sync::Mutex;

use serde::{Deserialize, Serialize};

use crate::websocket::CONNECTED_CLIENTS;
use layers::Animation;

#[derive(Serialize, Deserialize)]
pub struct StripLayers {
    pub layers: Vec<Animation>,
}

impl StripLayers {
    pub fn new() -> Self {
        Self { layers: Vec::new() }
    }
}

lazy_static! {
    pub static ref CURRENT_STATE: Mutex<StripLayers> = Mutex::new(StripLayers::new());
}

pub fn send_update() {
    let mut recipients = CONNECTED_CLIENTS.lock().unwrap();

    for (_uuid, addr) in recipients.iter_mut() {
        match addr.try_send(crate::websocket::Dummy) {
            Ok(_) => log::info!("a"),
            Err(e) => log::error!("{}", e),
        }
    }
}
