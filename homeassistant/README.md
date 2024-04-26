# HOME ASSISTANT SETUP

add these 2 lines in case of error: `<jemalloc>: Unsupported system page size`, they're already in the `docker-compose.yml` but commented out

    environment:
      - DISABLE_JEMALLOC=true

if you want to use zigbee dongles directly with ZHA integration (without using zigbee2mqtt), check the correct device under `/dev/serial/by-id` on the host, and change the DEVICE_ID in the following lines in the `docker-compose.yml`

    devices:
      - /dev/serial/by-id/DEVICE_ID:/dev/ttyUSB0

same can be done to pass bluetooth adapter to the container, please check on Home Assistant site and forums for info and help.
