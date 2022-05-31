use actix_web::{post, Responder, HttpResponse, web};
use layers::{static_layers::Color, rainbow_layers::Wheel};

use crate::state::{CURRENT_STATE, send_update};

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
