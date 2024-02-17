FROM alpine:edge
MAINTAINER Antonio Fragola <fragolino@gmail.com>

LABEL Description="Eclipse Mosquitto MQTT Broker server and clients"

ARG PUID
ARG PGID

RUN addgroup -g ${PGID} -S mosquitto && adduser -D -u ${PUID} -S mosquitto -G mosquitto && \
    apk add --no-cache mosquitto mosquitto-clients && \
    mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    cp /etc/mosquitto/mosquitto.conf /mosquitto/config && \
    touch /mosquitto/config/mosquitto.conf && \
    touch /mosquitto/log/mosquitto.log && \
    touch /mosquitto/log/mosquitto.db && \
    touch /mosquitto/config/passwd && \
    chown -R mosquitto:mosquitto /mosquitto && \
    chmod g+w -R /mosquitto

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
