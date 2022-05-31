use prisma::{FromColor, Hsv, Rgb};

use crate::animation::Animation;
use crate::Strip;
use std::sync::{Arc, Mutex};

use angle::Deg;

pub struct RainbowWheel {
    current_color: Hsv<f32, Deg<f32>>,
    initial_color: Hsv<f32, Deg<f32>>,
    step_size: Deg<f32>,
}

impl RainbowWheel {
    pub fn new(initial_color_hue: Deg<f32>, step_size: Deg<f32>) -> RainbowWheel {
        RainbowWheel {
            current_color: Hsv::new(initial_color_hue, 1.0, 1.0),
            initial_color: Hsv::new(initial_color_hue, 1.0, 1.0),
            step_size,
        }
    }
}

impl Animation for RainbowWheel {
    fn initialize(&mut self, _strip: Arc<Mutex<Strip>>) {
        self.current_color = self.initial_color;
    }

    fn update(&mut self, strip: Arc<Mutex<Strip>>) {

        let amount_leds = {
            strip.lock().unwrap().get_width()
        };

        *self.current_color.hue_mut() += self.step_size;
        *self.current_color.hue_mut() %= Deg(360.0);


        let mut value = self.current_color.clone();
        
        for i in 0..amount_leds {

            let rgb: Rgb<u8> = Rgb::from_color(&value).color_cast();

            {
                let mut strip = strip.lock().unwrap();
                strip.set_pixel(i, rgb);
            }

            *value.hue_mut() += self.step_size;
            *value.hue_mut() %= Deg(360.0);
        }

    }
}
