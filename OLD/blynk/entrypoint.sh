#!/bin/bash

cd /blynk
echo Getting latest info in JSON format
curl -s https://api.github.com/repos/blynkkk/blynk-server/releases/latest > latest.txt

echo Extracting latest filename and download url
filename=$(cat latest.txt | jq --raw-output '.assets[0] | .name')
file_url=$(cat latest.txt | jq --raw-output '.assets[0] | .browser_download_url')

echo Removing old versions, leave only latest, if present
for old in $(ls server-*-java8.jar | grep -v $filename) ; do rm -f $old ; done

echo Check if latest version is already downloaded, otherwise download it and soft-link it
[ ! -f $filename ] && curl -O -L $file_url
ln -sf $(ls server-*-java8.jar) server.jar

echo Download standard config file, only if missing
[ ! -f /blynk/config/server.properties ] && curl https://raw.githubusercontent.com/blynkkk/blynk-server/master/server/core/src/main/resources/server.properties > /blynk/config/server.properties

echo Starting up Blynk Local Server
#ls -lRa /blynk
echo All done.

exec "$@"

# end of file.
