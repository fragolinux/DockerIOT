# NODERED SETUP

set timezone in .env file, then change ownership to the data folder:

    chown -R 1000:1000 data

finally, startup as follows:

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
