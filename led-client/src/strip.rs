use layers::{BoxedLayer, Rgb};
use ws2818_rgb_led_spi_driver::{adapter_spi::WS28xxSpiAdapter, adapter_gen::WS28xxAdapter, encoding::encode_rgb};

/// This function can be used to write the top layer of the animation stack to the led strip
pub fn write_layer(adapter: &mut WS28xxSpiAdapter, layer: &BoxedLayer) { 
    let spi_encoded_bits = flatten_color_vec(layer.to_led_values());

    adapter.write_encoded_rgb(&spi_encoded_bits).unwrap();

}

/// This flattens a vector of Rgb colers to a vector of form (r, g, b ,r, g, b, ...)
fn flatten_color_vec(vector: &Vec<Rgb>) -> Vec<u8> {
    let mut flattened: Vec<u8> = Vec::new();

    for color in vector {
        let color = encode_rgb(color.red(), color.green(), color.blue());
        flattened.extend_from_slice(&color);
    }

    flattened
}
