# PORTAINER SETUP

change password in "pass.txt" (MUST be at least 12 chars...), then:

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
