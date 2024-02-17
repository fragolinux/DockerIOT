#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'You have to give a password as parameter to this script, and no spaces allowed... exiting...'
    exit 0
fi

echo -n "PASSWORD=" > .env
docker build -t htpasswd:mine .
docker run --rm -ti htpasswd:mine admin $1 | cut -d ":" -f 2 >> .env

