#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'You have to give a password as parameter to this script, and no spaces allowed... exiting...'
    exit 0
fi
cp -f data/web/phpliteadmin/phpliteadmin.config.stock.php data/web/phpliteadmin/phpliteadmin.config.php
sed -i -e "s#Passw0rd#$1#" data/web/phpliteadmin/phpliteadmin.config.php

