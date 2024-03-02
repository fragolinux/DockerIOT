# ZIGBEE2MQTT SETUP

change your mqtt settings under `data/configuration.yaml` (DO ***NOT*** TOUCH the serial port there!), then connect your usb zigbee dongle, check under `/dev/serial/by-id/` its device name and put it in the docker-compose.yml file, then:

startup:

    docker-compose up -d

shutdown:

    docker-compose down

logs (following):

    docker-compose logs -f

update:

    docker-compose down
    docker-compose pull
    docker-compose up -d --force-recreate
