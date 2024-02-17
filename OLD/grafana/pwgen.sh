#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'You have to give a password as parameter to this script, and no spaces allowed... exiting...'
    exit 0
fi

echo -n "PASSWORD=$1" > .env

