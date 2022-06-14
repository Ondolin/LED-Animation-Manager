#[macro_use]
extern crate lazy_static;

use actix_cors::Cors;
use actix_web::{middleware, web, App, Error, HttpRequest, HttpResponse, HttpServer};
use actix_web_actors::ws;
use dotenv::dotenv;
use std::env;
use websocket::WebSocketConnection;

use manipulate_layer::{ColorProp, CropFilterProps, ErrorResponse, TimerProps};

use utoipa_swagger_ui::SwaggerUi;

use utoipa::{
    openapi::security::{ApiKey, ApiKeyValue, SecurityScheme},
    Modify, OpenApi,
};

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
            manipulate_layer::add_crop_filter_layer,
            manipulate_layer::add_timer_layer,
            manipulate_layer::delete_by_uuid,
            manipulate_layer::switch_layers,
            manipulate_layer::change_color_layer
        ),
        components(ColorProp, ErrorResponse, TimerProps, CropFilterProps),
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
                "LED-API-KEY",
                SecurityScheme::ApiKey(ApiKey::Header(ApiKeyValue::new("LED-API-KEY"))),
            )
        }
    }

    // Make instance variable of ApiDoc so all worker threads gets the same instance.
    let openapi = ApiDoc::openapi();

    #[cfg(debug_assertions)]
    save_openapi_file(
        openapi.to_pretty_json().unwrap(),
        openapi.to_yaml().unwrap(),
    );

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

#[cfg(debug_assertions)]
fn save_openapi_file(json: String, yaml: String) {
    use std::fs::create_dir_all;
    use std::fs::File;
    use std::io::Write;

    create_dir_all("./api").unwrap();

    let mut json_file = File::create("./api/openapi.json").unwrap();
    let mut yaml_file = File::create("./api/openapi.yaml").unwrap();

    writeln!(&mut json_file, "{}", json).unwrap();
    writeln!(&mut yaml_file, "{}", yaml).unwrap();
}
