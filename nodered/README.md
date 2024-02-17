# NODERED SETUP

set timezone in .env file, then startup as follows:

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
