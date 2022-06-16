# LED client

## What is this?

This client recieves the current status of the LED strip from the server, and displays it onto a WS2812-led strip.

## Installation

Note that you will need to activate SPI on your device!

### Build from source

You will need to install the Rust programming language.

1. go to the led-client folder
2. fill in the enviroment variables within the `led-controller-client.service` file.
3. build the server using `cargo build --release`
4. The biary will be located at `../target/release/led-client`
5. run the systemd file as descriped in the server installation

Since this service is most likely to be used on a microcomputer running ARM, you can also crosscompile this app using [this](https://github.com/japaric/rust-cross) serice.
Due to the design of this project it will be nessessary to run the command on the parent folder.

### Install prebuild binary

There are prebuild linux versions of this packet available at [https://github.com/Ondolin/LED-Animation-Manager/releases](https://github.com/Ondolin/LED-Animation-Manager/releases).
