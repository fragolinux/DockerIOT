# Welcome to DockerIOT

Inspired by the excellent work of Peter Scargill ("[The Script](https://www.esp-go.com)") about an automatic installer of everything you need to start a platform useful to manage IOT devices, I'd like to convert that to a Docker container based setup, keeping all the easy install features you already are used to.

## Goals

- **easy install**: just run a script to select what you want to install, choose your credentials, let it run.
- **easy backup**: all user data will be in a single folder, which can be ported on an other device with Docker support and reinstalled in as low downtime as possible, or backupped via RSYNC or other methods via network or attached storage.
- **easy management**: thanks to scripts with a coherent user interface and to a user friendly web GUI ([Portainer](https://portainer.io))
- **easy update**: being based on Docker, you just need to drop your actual container, pull down an updated image, deploy a new container from that, start it again, finding all you previous data and configs just there, ready to work.
- **multi platform**: testing started on X86 hardware (a [CoreOS](https://coreos.com) virtual machine, really), but of course I'll do my best to port everything on SBCs like Raspberry Pi, Orange Pi, FriendlyArm NanoPi, Pine64 Rock64, and the like, on whatever platform a Docker daemon is available.
- **reuse of existing containers**: I don't want to reinvent the wheel, and I'll use standard, possibly official, containers whenever it's possible, and I'd like to use [Alpine Linux](https://hub.docker.com/_/alpine) Docker images if available, to reduce even more container size.

## What you'll get

- [Grafana](https://grafana.com) | The open platform for analytics and monitoring, already integrated with [InfluxDB](https://www.influxdata.com) | Time Series Database Monitoring & Analytics
- [Homarr](https://homarr.dev/) | A service dashboard
- [LEMP] | Linux/Nginx/MariaDB/PhpMyAdmin, full web stack
- [Home Assistant](https://www.home-assistant.io) | Open source home automation that puts local control and privacy first
- [Mosquitto](https://mosquitto.org) | An open source MQTT broker
- [NodeRED](https://nodered.org) | Flow-based programming for the Internet of Things
- [phpLiteAdmin](https://www.phpliteadmin.org) Web-based SQLite database admin tool written in PHP with support for SQLite3 and SQLite2, with [Peter Scargill](https://tech.scargill.net)'s IOT.DB already setup and connected 
- [Portainer](https://portainer.io) | Simple management UI for Docker
- [WatchTower](https://github.com/containrrr/watchtower) | A process for automating Docker container base image updates
- [zigbee2mqtt](https://www.zigbee2mqtt.io/) | Zigbee to MQTT bridge, get rid of your proprietary Zigbee bridges
- More to come...

## enable user root and root ssh login

I know, this is far from being secure and should be avoided, but as this simplifies operations for not skilled people, and in the end it's a local setup, this is what should be done to avoid me the headaches of having to help people with permission issues. You don't agree? Then feel free to study proper security measures and fix this yourself :)

    # give root user a password
    sudo passwd root

    # change these 2 lines in /etc/ssh/sshd_config to allow root login via ssh
    PermitRootLogin yes
    PasswordAuthentication yes
    
    # now restart ssh to apply changes without reboot
    sudo systemctl restart ssh

from now on, EVERY command you'll see MUST be run as root, so you'll not find any reference to sudo anymore

## basic tools requirements

before going on, you'll need some basic tools, like `jq` and `dialog` (both used by my new menu), and of course `git`, so please install them with something similar to this (adapt to your linux distro if it's not debian based):

    apt install -y jq dialog git

## install docker

    curl -fsSL https://get.docker.com -o get-docker.sh
    sh ./get-docker.sh
    docker --version

## install docker compose

    mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-$(uname -m) -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    docker compose version


## get a copy of this repo

    cd; git clone https://github.com/fragolinux/DockerIOT

## most common docker compose commands

startup:

    docker compose up -d

shutdown:

    docker compose down

logs (following):

    docker compose logs -f

update:

    docker compose down
    docker compose pull
    docker compose up -d --force-recreate

feel free to check `docker --help` and `docker compose --help` to learn a lot more, but this is enough to deal with this setup

## useful aliases

    alias docker-compose="docker compose"
    alias dstart="docker compose up -d"
    alias dstop="docker compose down"
    alias drestart="docker compose down; docker compose up -d"
    alias dlogs="docker compose logs -f"
    alias dupdate="docker compose down; docker compose pull; docker compose up -d --force-recreate"
    alias dsh="docker compose exec \$(grep -A1 services docker-compose.yml|tail -1|cut -d: -f1|awk '{\$1=\$1};1') /bin/sh"
    alias dbash="docker compose exec \$(grep -A1 services docker-compose.yml|tail -1|cut -d: -f1|awk '{\$1=\$1};1') /bin/bash"

note: the last 2 commands need a bit of tuning for docker-compose files containing more than a single service, I'll work on them ASAP

## BASIC BACKUP COMMANDS, to be run ALWAYS as root, till a proper backup procedure will be added

    # compress a full folder, PRESERVING permissions (change the date as you want)
    cd && tar cvzfp DockerIOT-20240414.tgz DockerIOT

    # decompress a full folder, PRESERVING permissions
    # BEWARE, risk of overwrite if something is already there in same folder, so better renaming the old one before with "mv DockerIOT DockerIOT-orig"
    cd && tar xvzfp DockerIOT-20240414.tgz

    # copy a folder from a linux system to an other, directly without windows:
    # BEWARE, risk of overwrite if something is already on the remote system...
    cd && scp -r DockerIOT root@192.168.1.X:/root

    # copy a single file from 1 system to an other:
    # SAFER way, as file is compressed and has a date in its name:
    cd && scp DockerIOT-20240414.tgz root@192.168.1.X:/root

## custom menu system

the `iotmenu.sh` script (call it using `bash iotmenu.sh` from inside the main DockerIOT folder) allows easy access to all the services, showing which one is running and on which ports, and all the above docker commands without having to remember their syntax.
