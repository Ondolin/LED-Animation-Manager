use std::time::Duration;

use actix_web::{
    post,
    web::{self, Data, ServiceConfig},
    HttpResponse, Responder,
};
use layers::{filter::Crop, info_layers::Timer, rainbow_layers::Wheel, static_layers::Color, Rgb};

use utoipa::{Component, IntoParams};

use crate::auth::RequireApiKey;

use crate::state::{send_update, CURRENT_STATE};

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Component)]
pub(super) enum ErrorResponse {
    /// When Todo is not found by search term.
    NotFound(String),
    /// When there is a conflict storing a new todo.
    Conflict(String),
    /// When todo enpoint was called without correct credentials
    Unauthorized(String),
}

pub(super) fn configure() -> impl FnOnce(&mut ServiceConfig) {
    |config: &mut ServiceConfig| {
        config.service(add_wheel_layer).service(add_color_layer);
    }
}

#[derive(Serialize, Deserialize, Component, Debug)]
pub struct ColorProp {
    pub red: u8,
    pub green: u8,
    pub blue: u8,
}

#[utoipa::path(
    request_body = ColorProp,
    responses(
        (status = 201, description = "Todo created successfully"),
        (status = 401, description = "Unauthorized to delete Todo", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Todo not found by id")
    ),
    security(
        ("api_key" = [])
    )
)]
#[post("/layers/add/color", wrap = "RequireApiKey")]
pub async fn add_color_layer(color: web::Json<ColorProp>) -> impl Responder {
    log::info!("Added color layer with color: {:?}", color);

    let mut state = CURRENT_STATE.lock().unwrap();

    let color = Rgb::new(color.red, color.green, color.blue);

    state.layers.push(Box::new(Color::new(color)));

    send_update();

    HttpResponse::Ok()
}

#[utoipa::path(
    responses(
        (status = 201, description = "Todo created successfully"),
    ),
    security(
        ("api_key" = [])
    )
)]
#[post("/layers/add/wheel")]
pub async fn add_wheel_layer() -> impl Responder {
    log::info!("Added wheel layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Wheel::new(layers::Deg(2.0))));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize)]
pub struct CropFilterProps {
    left: usize,
    right: usize,
}

// TODO check if amount of layers and parameter are right
#[post("/layers/add/filter/crop")]
pub async fn add_crop_filter_layer(crop_filter: web::Json<CropFilterProps>) -> impl Responder {
    log::info!("Added crop layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state
        .layers
        .push(Box::new(Crop::new(crop_filter.left, crop_filter.right)));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize)]
pub struct TimerProps {
    duration: u64,
    color: Rgb,
}

#[post("/layers/add/timer")]
pub async fn add_timer_layer(props: web::Json<TimerProps>) -> impl Responder {
    log::info!("Added new timer layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Timer::new(
        Duration::from_secs(props.duration),
        props.color,
    )));

    send_update();

    HttpResponse::Ok()
}
