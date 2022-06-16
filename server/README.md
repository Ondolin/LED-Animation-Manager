# Server

## What is this?

This server is the core of the LED-Manager.
It recieves status updates from clients, and distributes it via a WebSocket to other clients.

## Interface

This server can be accessed via a REST API.
To view the available routes, you can have a look at the `./api/openapi.yaml` file.

Additional to this REST API, there is a WebSocket located on the route `/live`.
It is only possible to recieve data using this route.

## Installation

### Build from source

You can build this project from source using the following instructions:

To build this packet you will need to install the rust programming language and OpenSSL.
If the build fails, it is also recommended to install `libssl-dev`, `cmake`, `build-essential`, `pkg-config`.

1. clone the repository
2. go to the server folder
3. start the server using `cargo build --release`
4. fill in the environment variables in the senvironment variables in the systemd file (you can generate an API Token by running `openssl rand -base64 24`)
5. fill in the absolute path to the binary (the path is by default`../target/release/server`)
6. symlink the systemd file to `/etc/systemd/system/`
7. reload the systemd deamon (`sudo systemctl daemon-reload`)
8. run the systemd service (`sudo systemctl start led-controller-server.service`)

Note that you can also run the server directly by running `cargo run --release`. You can do so if you do not have systemd (e.g. on macOS or windows).
