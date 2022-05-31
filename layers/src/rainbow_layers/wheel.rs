use crate::{Layer, Rgb, BoxedLayer, STRIP_SIZE};

use prisma::{Hsv, FromColor};
use serde::{Serialize, Deserialize};

use angular_units::Deg;
use uuid::Uuid;

#[derive(Serialize, Deserialize, Debug)]
struct Wheel {
    uuid: Uuid,
    step_size: Deg<f32>,
    #[serde(skip)]
    leds: Vec<Rgb>,
    #[serde(skip)]
    current_color: Hsv<f32, Deg<f32>>
}

impl Wheel {
    fn new(step_size: Deg<f32>) -> Wheel {
        Wheel {
            uuid: Uuid::new_v4(),
            leds: Default::default(),
            step_size,
            current_color: Hsv::new(Deg(0.0), 1.0, 1.0)
        }
    }
}

#[typetag::serde]
impl Layer for Wheel {
    fn initialize(&mut self, _previous_layers: &*const [BoxedLayer]) {}

    fn update(&mut self, _previous_layers: & *const[BoxedLayer]) {
        *self.current_color.hue_mut() += self.step_size;
        *self.current_color.hue_mut() %= Deg(360.0);

        let mut value = self.current_color.clone();
        
        for i in 0..*STRIP_SIZE {

            let rgb: Rgb = prisma::Rgb::from_color(&value).color_cast();

            self.leds[i] = rgb;

            *value.hue_mut() += self.step_size;
            *value.hue_mut() %= Deg(360.0);
        }


    }

    fn to_led_values(&self) -> &Vec<Rgb> { &self.leds }

    fn uuid(&self) -> Uuid {
        self.uuid
    }
}
