# GRAFANA and INFLUXDB SETUP

change all the needed parameters in both `.env` and `data/provisioning/datasources/datasource.yml` files

in nodered, setup an influxdb node using version 2.0, add url as `http://host:8086` and the token above, then complete the setup adding the same organization and bucket configured above, and add a measurement

NOTE: you MUST have a line in your `/etc/hosts` file pointing your device ip with a name `host`

## ONLY FOR 1st RUN!

on 1st run, use this different startup line:

    docker compose -f init-docker-compose.yml up -d

then monitor with

    docker compose -f init-docker-compose.yml logs -f

to see when everything is complete (logs are still, not going on), then shutdown with

    docker compose -f init-docker-compose.yml down
