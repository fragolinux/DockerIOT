# ZIGBEE2MQTT SETUP

set timezone in `.env` file, change your mqtt settings under `data/configuration.yaml` (DO ***NOT*** TOUCH the serial port there!), then connect your usb zigbee dongle, check under `/dev/serial/by-id/` its device name and put it in the `docker-compose.yml` file
