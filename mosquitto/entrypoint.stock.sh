#!/bin/sh

echo -e "\n\nlistener 9001\nprotocol websockets\nlistener 1883\nallow_anonymous false\npassword_file /mosquitto/config/passwd\npersistence true\npersistence_location /mosquitto/data/\nlog_dest file /mosquitto/log/mosquitto.log" >> /mosquitto/config/mosquitto.conf

PASSWDFILE=/mosquitto/config/passwd
USER=admin
PASS=Passw0rd

if [ ! -f $PASSWDFILE ]; then
    touch $PASSWDFILE
    mosquitto_passwd -b $PASSWDFILE $USER $PASS
fi
chown -R mosquitto:mosquitto /mosquitto

exec "$@"

