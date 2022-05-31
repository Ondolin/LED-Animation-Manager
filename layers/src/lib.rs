#[macro_use]
extern crate lazy_static;

use std::fmt::Debug;
use std::env;

use uuid::Uuid;

pub mod none;
pub use none::NoAnimation;

pub mod static_layers;
pub mod rainbow_layers;
pub mod filter;


pub type BoxedLayer = Box<dyn Layer>;
pub type Rgb = prisma::Rgb<u8>;

pub use angular_units::Deg;

#[typetag::serde(tag = "type")]
pub trait Layer: Send + Sync + Debug {
    fn initialize(&mut self, _previous_layers: &[BoxedLayer]);
    fn update(&mut self, _previous_layers: &[BoxedLayer]);
    fn to_led_values(&self) -> &Vec<Rgb>;
    fn uuid(&self) -> Uuid;
    // fn delete(&mut self, _previous_layers: Vec<Box<dyn Layer>>) { unimplemented!() }
}

pub fn initialize() { let _ = *STRIP_SIZE; }

lazy_static! {
    pub static ref STRIP_SIZE: usize = env::var("STRIP_SIZE").expect("Your need to specify a STRIP_SIZE").parse::<usize>().expect("The Strip size must be an integer");
}
