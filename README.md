## Welcome to DockerIOT

Inspired by the excellent work of Peter Scargill ("[The Script](https://www.esp-go.com)") about an automatic installer of everything you need to start a platform useful to manage IOT devices, I'd like to convert that to a Docker container based setup, keeping all the easy install features you already are used to.

# BEWARE: STILL IN EARLY STAGES, WORK IN PROGRESS!

### Goals

- **easy install**: just run a script to select what you want to install, choose your credentials, let it run.
- **easy backup**: all user data will be in a single folder, which can be ported on an other device with Docker support and reinstalled in as low downtime as possible, or backupped via RSYNC or other methods via network or attached storage.
- **easy management**: thanks to scripts with a coherent user interface and to a user friendly web GUI ([Portainer](https://portainer.io))
- **easy update**: being based on Docker, you just need to drop your actual container, pull down an updated image, deploy a new container from that, start it again, finding all you previous data and configs just there, ready to work.
- **multi platform**: testing started on X86 hardware (a [CoreOS](https://coreos.com) virtual machine, really), but of course I'll do my best to port everything on SBCs like Raspberry Pi, Orange Pi, FriendlyArm NanoPi, Pine64 Rock64, and the like, on whatever platform a Docker daemon is available. In the future I'd like to migrate to [Balena.io](https://www.balena.io) for its smaller footprint.
- **reuse of existing containers**: I don't want to reinvent the wheel, and I'll use standard, possibly official, containers whenever it's possible, and I'd like to use [Alpine Linux](https://hub.docker.com/_/alpine) Docker images if available, to reduce even more container size.

### What you'll get

- [Node-RED](https://nodered.org) | Flow-based programming for the Internet of Things
- [Mosquitto](https://mosquitto.org) | An open source MQTT broker
- [Homarr](https://homarr.dev/) | A service dashboard
- [Home Assistant](https://www.home-assistant.io) | Open source home automation that puts local control and privacy first, with integrated [HASS Configurator](https://www.home-assistant.io/addons/configurator)
- [Portainer](https://portainer.io) | Simple management UI for Docker
- [SQLite](https://www.sqlite.org) | Self-contained, high-reliability, embedded, full-featured, public-domain, SQL database engine, together with [phpLiteAdmin](https://www.phpliteadmin.org) (a web-based SQLite database admin tool written in PHP with support for SQLite3 and SQLite2) running on top of [Caddy](https://caddyserver.com) (a light HTTP/2 Web Server with Automatic HTTPS)
- [Grafana](https://grafana.com) | The open platform for analytics and monitoring
- [InfluxDB](https://www.influxdata.com) | Time Series Database Monitoring & Analytics, together with [Kapacitor](https://www.influxdata.com/time-series-platform/kapacitor) (Real-Time Stream Processing Engine), [Chronograf](https://www.influxdata.com/time-series-platform/chronograf) (Complete Interface for the InfluxData Platform) and [Telegraf](https://www.influxdata.com/time-series-platform/telegraf) (Agent for Collecting & Reporting Metrics & Data)
- More to come...
