#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'You have to give a password as parameter to this script, and no spaces allowed... exiting...'
    exit 0
fi
cp entrypoint.stock.sh entrypoint.sh
sed -i -e "s#Passw0rd#$1#" entrypoint.sh
echo -n -e "PUID=`id -u`\nPGID=`id -g`\n" > .env

