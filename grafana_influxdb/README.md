# GRAFANA and INFLUXDB SETUP

change all the needed parameters in both `.env` and `data/provisioning/datasources/datasource.yml` files

in nodered, setup an influxdb node using version 2.0, add url as http://yourip:8086 and the token above, then complete the setup adding the same organization and bucket configured above, and add a measurement

## ONLY FOR 1st RUN!

on 1st run, use this different startup line:

    docker-compose -f init-docker-compose.yml up -d

then monitor with

    docker-compose logs -f

to see when everything is complete (logs are still, not going on), then shutdown with

    docker-compose down

from now on, use normal startup as below:

startup:

    docker-compose up -d

shutdown:

    docker-compose down

logs (following):

    docker-compose logs -f

update:

    docker-compose down
    docker-compose pull
    docker-compose --force-recreate up -d
