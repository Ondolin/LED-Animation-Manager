use actix_web::{post, Responder, HttpResponse, web};
use layers::{static_layers::Color, rainbow_layers::Wheel, filter::Crop};

use crate::state::{CURRENT_STATE, send_update};

use serde::{Serialize, Deserialize};

#[post("/layers/add/color")]
pub async fn add_color_layer(color: web::Json<layers::Rgb>) -> impl Responder {
    log::info!("Added color layer with color: {}", color );
    
    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Color::new(color.into_inner())));

    send_update();
        
    HttpResponse::Ok()
}

#[post("/layers/add/wheel")]
pub async fn add_wheel_layer() -> impl Responder {
    log::info!("Added wheel layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Wheel::new(layers::Deg(2.0))));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize)]
pub struct CropFilter {
    left: usize,
    right: usize
}

// TODO check if amount of layers and parameter are right
#[post("/layers/add/filter/crop")]
pub async fn add_crop_filter_layer(crop_filter: web::Json<CropFilter>) -> impl Responder {
    log::info!("Added crop layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Crop::new(crop_filter.left, crop_filter.right)));

    send_update();

    HttpResponse::Ok()

}
