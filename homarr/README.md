# HOMARR SETUP

set timezone in .env file

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
