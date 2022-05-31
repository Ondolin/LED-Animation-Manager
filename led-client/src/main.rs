use std::{sync::Arc, env, ptr::slice_from_raw_parts};

use diplomatic_bag::DiplomaticBag;
use dotenv::dotenv;
use fps_clock::FpsClock;
use strip::write_layer;
use tokio_tungstenite::connect_async;
use tokio::sync::Mutex;
use futures_util::{StreamExt, SinkExt};
use url::Url;
use ws2818_rgb_led_spi_driver::adapter_spi::WS28xxSpiAdapter;

use crate::state::StripLayers;

mod state;
mod strip;

#[tokio::main]
async fn main() {

    dotenv().ok();

    layers::initialize();

    env::var("SERVER_HOST").expect("You need to specify a server host.");
    env::var("SERVER_PORT").expect("You need to specify a server port.");
    env::var("FRAMES_PER_SECOND").expect("You need to specify the frames per second.")
        .parse::<u32>().expect("The frames per second have to be an Integer");

    let layers: Arc<Mutex<StripLayers>> = Arc::new(Mutex::new(StripLayers::new()));

    tokio::spawn(manage_stip(layers.clone()));

    let url = Url::parse(format!("ws://{}:{}/live", env::var("SERVER_HOST").unwrap(), env::var("SERVER_PORT").unwrap()).as_str()).unwrap();

    let (ws_stream, _) = connect_async(&url).await.expect(format!("Could not connect to websocket on url: {:?}", url).as_str());

    let (mut write, read) = ws_stream.split();

    tokio::spawn(async move {
        let mut fps = FpsClock::new(1);
        loop {
    
            write.send(tokio_tungstenite::tungstenite::Message::Pong(vec![])).await.unwrap();

            fps.tick();
        };
    });

    read.for_each(|message| async {

        let data = message.unwrap().into_data();


        if let Ok(new_data) = serde_json::from_slice::<StripLayers>(&data) {
            let mut layers = layers.lock().await;
            
            let mut new_layers: StripLayers = StripLayers::new();

            'outer: for mut new_layer in new_data.layers {
                
                let uuid = new_layer.uuid();

                for (index, old_layer) in layers.layers.iter().enumerate() {
                    if uuid == old_layer.uuid() {

                        let old_layer = layers.layers.remove(index);

                        new_layers.push_layer(old_layer);
                        continue 'outer;
                    }
                }

                new_layer.initialize(&slice_from_raw_parts(new_layers.layers.as_ptr(), new_layers.layers.len()));
                new_layers.push_layer(new_layer);

            }

            
            println!("New Layer: {:?}", new_layers);

            *layers = new_layers;

        } else {
            log::warn!("Could not parse data: {:?}", data);
        }

    }).await

}

async fn manage_stip(strip: Arc<Mutex<StripLayers>>) {
    let mut fps = FpsClock::new(env::var("FRAMES_PER_SECOND").unwrap().parse::<u32>().unwrap());

    let mut adapter = DiplomaticBag::new(|_| WS28xxSpiAdapter::new("/dev/spidev0.0").expect("Could not access device /dev/spidev0.0."));

    loop {

        fps.tick();
       
        let mut strip = strip.lock().await;

        let amount_layers = {
            strip.layers.len()
        };

        {
            let layers = &*strip.layers;
            let ptr = layers.as_ptr();


            for i in 0..amount_layers {
                if i == 0 {
                    strip.layers[i].update(&slice_from_raw_parts(ptr, 0));
                } else {
                    strip.layers[i].update(&slice_from_raw_parts(ptr, i - 1));
                }
            }
        }

        
        if amount_layers == 0 {
            println!("No layer pesent");
            let no: Box<dyn layers::Layer> = Box::new(layers::NoAnimation::new());
            adapter.as_mut().map(|_, mut adapter| write_layer(&mut adapter, &no));
        } else {
            adapter.as_mut().map(|_, mut adapter| write_layer(&mut adapter, &strip.layers[amount_layers - 1]));
        }
        
    }

}
