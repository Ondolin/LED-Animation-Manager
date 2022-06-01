run-on-led-strip:
    cross build --target armv7-unknown-linux-gnueabihf --release
    ssh LED_STRIP 'cd /home/pi/led; killall --quiet ./led-client'
    scp ./target/armv7-unknown-linux-gnueabihf/release/led-client LED_STRIP:/home/pi/led
    ssh LED_STRIP 'cd /home/pi/led; ./led-client'
