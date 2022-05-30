use std::time::{Instant, Duration};

use std::{collections::HashMap, sync::Mutex};

use actix::prelude::*;
use actix_web_actors::ws;

use uuid::Uuid;

use crate::state::{CURRENT_STATE, StripLayers};

const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(5);
const CLIENT_TIMEOUT: Duration = Duration::from_secs(5);

lazy_static! {
    pub static ref CONNECTED_CLIENTS: Mutex<HashMap<Uuid, actix::Addr<WebSocketConnection>>> = Mutex::new(HashMap::new());
}

pub struct WebSocketConnection {
    hb: Instant,
    id: Uuid
}

impl WebSocketConnection {
    pub fn new() -> Self {
        Self {
            hb: Instant::now(),
            id: Uuid::new_v4()
        }
    }

    // heart beat messages
    fn hb(&mut self, ctx: &mut <Self as Actor>::Context) {
        ctx.run_interval(HEARTBEAT_INTERVAL, |act, ctx| {
            // check client heartbeats
            if Instant::now().duration_since(act.hb) > CLIENT_TIMEOUT {
                // heartbeat timed out
                log::warn!("Websocket Client heartbeat failed, disconnecting!");

                // stop actor
                ctx.stop();

                // don't try to send a ping
                return;
            }

            ctx.ping(b"");
        });
    }

}

impl Message for StripLayers {
    type Result = Result<(), ()>;
}

impl Handler<StripLayers> for WebSocketConnection {
    type Result = Result<(), ()>;

    fn handle(&mut self, msg: StripLayers, ctx: &mut Self::Context) -> Self::Result {
        ctx.binary(serde_json::to_vec(&msg).unwrap());

        Ok(())
    }
}

impl Actor for WebSocketConnection {
    type Context = ws::WebsocketContext<Self>;

    fn started(&mut self, ctx: &mut Self::Context) {
        log::info!("New Client connected.");

        self.hb(ctx);

        // send current state at the beginning of the connection
        {

            let state = CURRENT_STATE.lock().unwrap();

            ctx.binary(serde_json::to_vec(&*state).unwrap());

        }

        // add new client to connected clients array
        {

            let mut address_array = CONNECTED_CLIENTS.lock().unwrap();

            address_array.insert(self.id, ctx.address());

        }

    }

    fn stopped(&mut self, _ctx: &mut Self::Context) {
        let mut address_array = CONNECTED_CLIENTS.lock().unwrap();

        match address_array.remove(&self.id) {
            Some(_) => log::info!("Client disconnected."),
            None => log::error!("Cound not disconnect client!")
        }
    }
}

/// Handler for `ws::Message`
impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for WebSocketConnection {
    fn handle(&mut self, msg: Result<ws::Message, ws::ProtocolError>, ctx: &mut Self::Context) {
        match msg {
            Ok(ws::Message::Ping(msg)) => {
                self.hb = Instant::now();
                ctx.pong(&msg);
            }
            Ok(ws::Message::Pong(_)) => {
                self.hb = Instant::now();
            }
            Ok(ws::Message::Text(_)) => ctx.text("Your message was ignored!"),
            Ok(ws::Message::Binary(_)) => ctx.text("Your message was ignored!"),
            Ok(ws::Message::Close(reason)) => {
                ctx.close(reason);
                ctx.stop();
            }
            _ => ctx.stop(),
        }
    }
}
