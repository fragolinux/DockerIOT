FROM alpine:edge
MAINTAINER Antonio Fragola <fragolino@gmail.com>

LABEL Description="Blynk Local Server"

RUN apk update && apk upgrade --no-cache && \
    mkdir -p /blynk/data && \
    mkdir /blynk/config && \
    mkdir /blynk/logs && \
    touch /blynk/logs/server.log && \
    touch /blynk/logs/blynk.log && \
    touch /blynk/logs/worker.log && \
    apk add --no-cache openjdk8-jre curl jq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD java -jar /blynk/server.jar -dataFolder /blynk/data -serverConfig /blynk/config/server.properties > /blynk/logs/server.log & \
    tail -f /blynk/logs/*.log

