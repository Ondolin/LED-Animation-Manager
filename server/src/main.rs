#[macro_use]
extern crate lazy_static;

use actix_cors::Cors;
use actix_web::{
    dev::{Service, ServiceRequest, ServiceResponse, Transform},
    middleware, web, App, Error, HttpRequest, HttpResponse, HttpServer,
};
use actix_web_actors::ws;
use dotenv::dotenv;
use std::{
    env,
    future::{self, Ready},
};
use websocket::WebSocketConnection;

use manipulate_layer::{
    add_color_layer, add_crop_filter_layer, add_timer_layer, add_wheel_layer, ColorProp,
    ErrorResponse,
};

use utoipa_swagger_ui::SwaggerUi;

use utoipa::{
    openapi::security::{ApiKey, ApiKeyValue, SecurityScheme},
    Modify, OpenApi,
};

use futures::future::LocalBoxFuture;

mod auth;
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

    #[derive(OpenApi)]
    #[openapi(
        handlers(
            manipulate_layer::add_wheel_layer,
            manipulate_layer::add_color_layer,
        ),
        components(ColorProp, ErrorResponse),
        tags(
            (name = "LED-Animation-Manager Server", description = "A server to distribute LED-Strip animations.")
        ),
        modifiers(&SecurityAddon)
    )]
    struct ApiDoc;

    struct SecurityAddon;

    impl Modify for SecurityAddon {
        fn modify(&self, openapi: &mut utoipa::openapi::OpenApi) {
            let components = openapi.components.as_mut().unwrap(); // we can unwrap safely since there already is components registered.
            components.add_security_scheme(
                "api_key",
                SecurityScheme::ApiKey(ApiKey::Header(ApiKeyValue::new("led_api_key"))),
            )
        }
    }

    // Make instance variable of ApiDoc so all worker threads gets the same instance.
    let openapi = ApiDoc::openapi();

    log::info!(
        "Starting HTTP server at port {}",
        env::var("SERVER_PORT").unwrap()
    );

    HttpServer::new(move || {
        let cors = Cors::permissive();

        App::new()
            .service(web::resource("/live").route(web::get().to(websocket_connection)))
            .configure(manipulate_layer::configure())
            .service(
                SwaggerUi::new("/swagger-ui/{_:.*}").url("/api-doc/openapi.json", openapi.clone()),
            )
            .wrap(cors)
            .wrap(middleware::Logger::default())
    })
    .bind(format!("0.0.0.0:{}", env::var("SERVER_PORT").unwrap()))?
    .run()
    .await
}

fn check_enviroment_variables() {
    env::var("SERVER_PORT").expect("You need to specify a SERVER_PORT in an .env file.");
    env::var("API_KEY").expect("You need to specify an API_KEY in the .env file");
}
