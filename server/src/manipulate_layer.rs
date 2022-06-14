use std::{str::FromStr, time::Duration};

use actix_web::{
    delete, post,
    web::{self, ServiceConfig},
    HttpResponse, Responder,
};
use layers::{
    filter::Crop, info_layers::Timer, rainbow_layers::Wheel, static_layers::Color, BoxedLayer,
    Layer, Rgb,
};

use utoipa::{Component, IntoParams};

use crate::auth::RequireApiKey;

use crate::state::{send_update, CURRENT_STATE};

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Component)]
pub(super) enum ErrorResponse {
    NotFound(String),
    Conflict(String),
    Unauthorized(String),
}

pub(super) fn configure() -> impl FnOnce(&mut ServiceConfig) {
    |config: &mut ServiceConfig| {
        config
            .service(add_wheel_layer)
            .service(add_color_layer)
            .service(add_crop_filter_layer)
            .service(add_timer_layer)
            .service(switch_layers)
            .service(delete_by_uuid)
            .service(change_color_layer);
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
        (status = 200, description = "Added layer successfully"),
        (status = 401, description = "Unauthorized to update the layer!", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse a color")
    ),
    security(
        ("LED-API-KEY" = [])
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

#[derive(Serialize, Deserialize, IntoParams, Debug)]
pub struct Uuid_change_color {
    uuid: String,
}

#[utoipa::path(
    request_body = ColorProp,
    responses(
        (status = 200, description = "Updated layer successfully"),
        (status = 401, description = "Unauthorized to update the layer!", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse a color")
    ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[post("/layers/update/color/", wrap = "RequireApiKey")]
pub async fn change_color_layer(
    color: web::Json<ColorProp>,
    id: web::Query<Uuid_change_color>,
) -> impl Responder {
    let mut state = CURRENT_STATE.lock().unwrap();

    let uuid = uuid::Uuid::from_str(&id.uuid);

    let uuid = match uuid {
        Ok(uuid) => uuid,
        Err(_) => return HttpResponse::NotFound(),
    };

    for (index, layer) in state.layers.iter().enumerate() {
        if layer.uuid() == uuid {
            let color = Rgb::new(color.red, color.green, color.blue);

            let new_layer: BoxedLayer =
                Box::new(layers::static_layers::Color::new_with_uuid(color, uuid));

            // state.layers.split_mut(index, new_layer);

            let _ = std::mem::replace(&mut state.layers[index], new_layer);

            log::error!("{:?}", &state.layers);

            send_update();
            return HttpResponse::Ok();
        }
    }

    HttpResponse::NotFound()
}

#[utoipa::path(
    responses(
        (status = 200, description = "Added layer successfully"),
        (status = 401, description = "Unauthorized to add a layer", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
    ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[post("/layers/add/wheel", wrap = "RequireApiKey")]
pub async fn add_wheel_layer() -> impl Responder {
    log::info!("Added wheel layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Wheel::new(layers::Deg(2.0))));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize, Component)]
pub struct CropFilterProps {
    left: usize,
    right: usize,
}

#[utoipa::path(
    request_body = CropFilterProps,
    responses(
        (status = 200, description = "Added layer successfully"),
        (status = 401, description = "Unauthorized to add layer", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse a options")
    ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[post("/layers/add/filter/crop", wrap = "RequireApiKey")]
pub async fn add_crop_filter_layer(crop_filter: web::Json<CropFilterProps>) -> impl Responder {
    log::info!("Added crop layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state
        .layers
        .push(Box::new(Crop::new(crop_filter.left, crop_filter.right)));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize, Component)]
pub struct TimerProps {
    duration: u64,
    color: ColorProp,
}

#[utoipa::path(
    request_body = TimerProps,
    responses(
        (status = 200, description = "Added layer successfully"),
        (status = 401, description = "Unauthorized to delete Todo", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse a color")
    ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[post("/layers/add/timer", wrap = "RequireApiKey")]
pub async fn add_timer_layer(props: web::Json<TimerProps>) -> impl Responder {
    log::info!("Added new timer layer.");

    let mut state = CURRENT_STATE.lock().unwrap();
    state.layers.push(Box::new(Timer::new(
        Duration::from_secs(props.duration),
        layers::Rgb::new(props.color.red, props.color.green, props.color.blue),
    )));

    send_update();

    HttpResponse::Ok()
}

#[derive(Serialize, Deserialize, IntoParams, Debug)]
pub struct Uuid {
    uuid: String,
}

#[utoipa::path(
    // request_body = Uuid,
    responses(
        (status = 200, description = "Layer deleted successfully."),
        (status = 401, description = "Unauthoriesed to deleat this layer.", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse a uuid from request, or there is no layer corresponding to your uuid.")
    ),
    // params(
    //     ("uuid", description = "")
    // ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[delete("/layer", wrap = "RequireApiKey")]
pub async fn delete_by_uuid(uuid: web::Query<Uuid>) -> impl Responder {
    let mut state = CURRENT_STATE.lock().unwrap();
    for (index, layer) in state.layers.iter().enumerate() {
        if layer.uuid().to_string() == uuid.uuid {
            state.layers.remove(index);
            send_update();
            return HttpResponse::Ok();
        }
    }

    HttpResponse::NotFound()
}

#[derive(Serialize, Deserialize, IntoParams, Debug)]
pub struct SwitchLayerProps {
    from: usize,
    to: usize,
}

#[utoipa::path(
    responses(
        (status = 200, description = "Layers swiched successfully!"),
        (status = 401, description = "Unauthoriesed to switch this layer.", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
        (status = 400, description = "Could not parse layer index")
    ),
    // params(
    //     ("uuid", description = "")
    // ),
    security(
        ("LED-API-KEY" = [])
    )
)]
#[post("/layers/switch", wrap = "RequireApiKey")]
pub async fn switch_layers(params: web::Query<SwitchLayerProps>) -> impl Responder {
    let mut state = CURRENT_STATE.lock().unwrap();

    println!("{:?} {:?}", params, state.layers.len());
    if params.from > state.layers.len() || params.to > state.layers.len() {
        return HttpResponse::NotFound();
    }

    let removed_layer = state.layers.remove(params.from);

    if params.to > state.layers.len() {
        state.layers.push(removed_layer);
    } else {
        state.layers.insert(params.to, removed_layer);
    }

    send_update();

    HttpResponse::Ok()
}
