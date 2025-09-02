# Telemetrix-Pharo
Pharo interfaces to Telemetrix Servers

Telemetrix (https://mryslab.github.io/telemetrix/) is a modern variant of Firmata. It consist of standalone servers written in C++ running on a number of different microprocessors (e.g. Arduino, ESP32, RP2040) and corresponding Python libraries to control these microprocessors. Communication can be through serial/USB, WiFi or BLE.

The basic concept is that commands are transmitted to the server and servers report asynchronously all pin changes or other relevant events. In the Python-API the responses are handled through callbacks.

This project aims to provide Pharo drivers for these servers (starting with the Arduino Nano RP2040 Connect). The basic structure will be that commands are sent to the server, while a reading loop will convert the messages from the server to Pharo announcements.
