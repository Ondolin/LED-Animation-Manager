use std::{env, sync::Arc};

use diplomatic_bag::DiplomaticBag;
use dotenv::dotenv;
use fps_clock::FpsClock;
use futures_util::{SinkExt, StreamExt};
use strip::write_layer;
use tokio::sync::Mutex;
use tokio_tungstenite::connect_async;
use url::Url;
use ws2818_rgb_led_spi_driver::adapter_spi::WS28xxSpiAdapter;

use crate::state::StripLayers;

mod state;
mod strip;

#[tokio::main]
async fn main() {
    dotenv().ok();
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    layers::initialize();

    env::var("SERVER_HOST").expect("You need to specify a server host.");
    env::var("SERVER_PORT").expect("You need to specify a server port.");
    env::var("FRAMES_PER_SECOND")
        .expect("You need to specify the frames per second.")
        .parse::<u32>()
        .expect("The frames per second have to be an Integer");

    let layers: Arc<Mutex<StripLayers>> = Arc::new(Mutex::new(StripLayers::new()));

    tokio::spawn(manage_stip(layers.clone()));

    let url = Url::parse(
        format!(
            "ws://{}:{}/live",
            env::var("SERVER_HOST").unwrap(),
            env::var("SERVER_PORT").unwrap()
        )
        .as_str(),
    )
    .unwrap();

    let (ws_stream, _) = connect_async(&url)
        .await
        .unwrap_or_else(|_| panic!("Could not connect to websocket on url: {:?}", url));

    let (mut write, read) = ws_stream.split();

    tokio::spawn(async move {
        let mut fps = FpsClock::new(1);
        loop {
            write
                .send(tokio_tungstenite::tungstenite::Message::Pong(vec![]))
                .await
                .unwrap();

            fps.tick();
        }
    });

    read.for_each(|message| async {
        if !(message.is_err()
            || message.as_ref().unwrap().is_ping()
            || message.as_ref().unwrap().is_pong())
        {
            let data = message.unwrap().into_data();

            if let Ok(new_data) = serde_json::from_slice::<StripLayers>(&data) {
                let mut layers = layers.lock().await;

                let mut new_layers: StripLayers = StripLayers::new();

                'outer: for mut new_layer in new_data.layers {
                    let uuid = new_layer.uuid();

                    for (index, old_layer) in layers.layers.iter().enumerate() {
                        if uuid == old_layer.uuid() {
                            let old_layer = layers.layers.remove(index);

                            new_layers.push_layer(new_layer);

                            continue 'outer;
                        }
                    }

                    new_layer.initialize(&new_layers.layers);
                    new_layers.push_layer(new_layer);
                }

                log::info!("New Layer: {:?}", new_layers);

                *layers = new_layers;
            } else {
                log::warn!("Could not parse data: {:?}", data);
            }
        }
    })
    .await
}

async fn manage_stip(strip: Arc<Mutex<StripLayers>>) {
    let mut fps = FpsClock::new(
        env::var("FRAMES_PER_SECOND")
            .unwrap()
            .parse::<u32>()
            .unwrap(),
    );

    let mut adapter = DiplomaticBag::new(|_| {
        WS28xxSpiAdapter::new("/dev/spidev0.0").expect("Could not access device /dev/spidev0.0.")
    });

    loop {
        fps.tick();

        let mut strip = strip.lock().await;

        let amount_layers = { strip.layers.len() };

        {
            if amount_layers > 0 {
                for i in 0..=amount_layers {
                    if let Some((new_layer, previous_layers)) = strip.layers[0..i].split_last_mut()
                    {
                        new_layer.update(previous_layers);
                    } else {
                        strip.layers[i].update(&[]);
                    }
                }
            }
        }

        if amount_layers == 0 {
            println!("No layer pesent");
            let no: Box<dyn layers::Layer> = Box::new(layers::NoAnimation::new());
            adapter
                .as_mut()
                .map(|_, adapter| write_layer(adapter, &no));
        } else {
            adapter
                .as_mut()
                .map(|_, adapter| write_layer(adapter, &strip.layers[amount_layers - 1]));
        }
    }
}
