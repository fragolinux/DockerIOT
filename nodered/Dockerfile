FROM nodered/node-red-docker:slim-v8
MAINTAINER Antonio Fragola <fragolino@gmail.com>

LABEL Description="Node-Red Server with addon node packages pre-installed"

USER root
RUN apk add --no-cache python make g++ gcc linux-headers udev
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

USER node
RUN mkdir /home/node/app \
    && mkdir /home/node/.npm-global \
    && npm install npm@latest -g

WORKDIR /home/node/app
COPY package.json /home/node/app
RUN npm install serialport --build-from-source=serialport && npm install

