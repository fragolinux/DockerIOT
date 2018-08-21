FROM alpine:edge
MAINTAINER Antonio Fragola <fragolino@gmail.com>

LABEL Description="Eclipse Mosquitto MQTT Broker server and clients"

RUN apk add --no-cache mosquitto mosquitto-clients && \
    mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    cp /etc/mosquitto/mosquitto.conf /mosquitto/config && \
    chown -R mosquitto:mosquitto /mosquitto

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
