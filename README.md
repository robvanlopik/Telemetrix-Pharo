# Telemetrix-Pharo
Pharo interfaces to Telemetrix Servers

Telemetrix (https://mryslab.github.io/telemetrix/) is a modern variant of Firmata. It consists of standalone servers written in Arduino - C++ running on a number of different microprocessors (e.g. Arduino, ESP32, RP2040) and corresponding Python libraries to control these microprocessors. Communication can be through serial/USB, WiFi or BLE, depending on the processor.

The basic concept is that commands are transmitted to the server and servers report asynchronously all pin changes or other relevant events. In the Python-API the responses are handled through callbacks.

This project aims to provide Pharo drivers for these servers (at present ESP32, Arduino Uno and Arduino Nano RP2040 Connect). The basic structure is that commands are sent to the server, while a reading loop converts the messages from the server to Pharo announcements. At the same time these announcements are also stored in an instance variable, so for synchronous use the latest value can always be retrieved.

Depending on the microprocessor the Telemtrix servers support standard analog and ditial i/o, PWM and servo, i2c, spi (to be done), stepper motors, DHT temperature and humidity sensors, ultrasonic distance sensors, and Neopixel LED strips.

The drivers can also be used with Pots (github://robvanlopik/Pots).
## Usage
The driver is initialized by naming its IP address or Serial port name, like:
```smalltalk
esp := TMXESP32Driver onIP: '192.168.1.5'.
nano2040 := TMXNano2040Driver onIP: 'mynano.lan'.
uno := TMXUnoDriver onPort: 'COM4'.
```

## Installation
## Notes
