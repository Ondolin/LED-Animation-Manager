#[macro_use]
extern crate lazy_static;

#[macro_use]
extern crate static_assertions;

use std::env;

pub mod none;
pub use none::NoAnimation;

pub mod filter;
pub mod rainbow_layers;
pub mod static_layers;
pub mod info_layers;

pub type Rgb = prisma::Rgb<u8>;

pub use angular_units::Deg;

use serde::{Serialize, Deserialize};
use uuid::Uuid;

pub trait Layer {
    fn initialize(&mut self, _previous_layers: &[Animation]);
    fn update(&mut self, _previous_layers: &[Animation]);
    fn to_led_values(&self) -> &Vec<Rgb>;
}

macro_rules! animation_enum {
    ($($name:ident),*) => (

        #[derive(Serialize, Deserialize, Debug, PartialEq)]
        #[serde(tag = "_type")]
        pub enum Animation {
            $(
                $name($name),
            )*
        }

        $(
            assert_impl_all!($name: Layer);
        )*

        impl Animation {
            pub fn initialize(&mut self, previous_layers: &[Animation]) {
                match self {
                    $(
                        Animation::$name(data) => {
                            data.initialize(previous_layers);
                        }
                    )*
                }
            }
            pub fn update(&mut self, previous_layers: &[Animation]) {
                match self {
                    $(
                        Animation::$name(data) => {
                            data.update(previous_layers);
                        }
                    )*
                }
            }
            pub fn to_led_values(&self) -> &Vec<Rgb> {
                match self {
                    $(
                        Animation::$name(data) => {
                            data.to_led_values()
                        }
                    )*
                }
            }

            pub fn uuid(&self) -> Uuid {
                match self {
                    $(
                        Animation::$name(data) => {
                            data.uuid()
                        }
                    )*
                }
            }
        }
    )
}

use rainbow_layers::RainbowWheel;
use filter::Crop;
use static_layers::Color;
use info_layers::Timer;

animation_enum!(
    NoAnimation,
    RainbowWheel,
    Crop,
    Color,
    Timer
);

pub fn initialize() {
    let _ = *STRIP_SIZE;
}

lazy_static! {
    pub static ref STRIP_SIZE: usize = env::var("STRIP_SIZE")
        .expect("Your need to specify a STRIP_SIZE")
        .parse::<usize>()
        .expect("The Strip size must be an integer");
}
