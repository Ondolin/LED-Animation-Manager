#[macro_use]
extern crate lazy_static;

use actix_cors::Cors;
use actix_web::{middleware, web, App, Error, HttpRequest, HttpResponse, HttpServer};
use actix_web_actors::ws;
use dotenv::dotenv;
use std::env;
use websocket::WebSocketConnection;

use manipulate_layer::{add_color_layer, add_crop_filter_layer, add_wheel_layer};

mod manipulate_layer;
mod state;
mod websocket;

async fn websocket_connection(
    req: HttpRequest,
    stream: web::Payload,
) -> Result<HttpResponse, Error> {
    ws::start(WebSocketConnection::new(), &req, stream)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    check_enviroment_variables();

    log::info!(
        "Starting HTTP server at port {}",
        env::var("SERVER_PORT").unwrap()
    );

    HttpServer::new(move || {
        let cors = Cors::permissive();

        App::new()
            .service(web::resource("/live").route(web::get().to(websocket_connection)))
            .service(add_color_layer)
            .service(add_wheel_layer)
            .service(add_crop_filter_layer)
            .wrap(cors)
            .wrap(middleware::Logger::default())
    })
    .bind(format!("0.0.0.0:{}", env::var("SERVER_PORT").unwrap()))?
    .run()
    .await
}

fn check_enviroment_variables() {
    env::var("SERVER_PORT").expect("You need to specity a SERVER_PORT in an .env file.");
}
