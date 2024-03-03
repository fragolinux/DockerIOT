# PHPLITEADMIN SETUP

put your sqlite DBs in the `dbs` folder, 1 level up of this one
change password in "docker-compose.yml", then:

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
