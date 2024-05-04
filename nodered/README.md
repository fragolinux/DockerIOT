# NODERED SETUP

set timezone in `.env` file, then run this, which will set up everything automatically, fixing permissions, creating ssh keys, etc:

    bash setup.sh

## OPTIONAL: to access the sqlite db (if needeed)

the `dbs` line is already uncommented in the docker compose file and will be available in nodered under `/dbs`, so, for example, `/dbs/iot.db` is the default.

## OPTIONAL: to allow access to host devices, like serial ports, or bluetooth, or whatever

check the device id you want to pass through to the container:

    ls /dev/serial/by-id

then set this device in `.env` file, uncomment the 4 lines you see in the `docker-compose.yml` file, and RESTART the container.

## OPTIONAL: to add EXEC permission on the host

BEWARE, HIGHLY INSECURE if nodered exposed to public and not well protected, the ssh keypair that will be used will allow FULL ROOT ACCESS to the underlying HOST OS!!!

The setup script above will take care of everything you need to use ssh from nodered container to host with no password needed, and the needed volume with the generated ssh keys is already mounted in the docker compose file.

Sample flow showing how to run commands on the host: DON'T TOUCH the COMMAND text box you see, it MUST be `ssh host`, exactly this, as `host` is the name configured in the ssh config file, it's CORRECT this way!

This command will ALWAYS be the same, while you need to add the command you want to exec on the host in the second text box of the node, the one between "append" and "output" (`ls /root/DockerIOT` in this example):

    [{"id":"1b1395421945f1a2","type":"tab","label":"Flow 1","disabled":false,"info":"","env":[]},{"id":"365e3bba8d3fb277","type":"inject","z":"1b1395421945f1a2","name":"","props":[{"p":"payload"},{"p":"topic","vt":"str"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"","payloadType":"date","x":320,"y":320,"wires":[["d889a35bfcc63c2f"]]},{"id":"d889a35bfcc63c2f","type":"exec","z":"1b1395421945f1a2","command":"ssh host","addpay":"","append":"ls /root/DockerIOT","useSpawn":"false","timer":"","winHide":false,"oldrc":false,"name":"SSH-HOST","x":550,"y":320,"wires":[["2bbd7f95a746914a"],[],[]]},{"id":"2bbd7f95a746914a","type":"debug","z":"1b1395421945f1a2","name":"debug 1","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":760,"y":320,"wires":[]}]

inject a timestamp, you'll get the content of that folder in the debug node, there will be a little delay, about 1 second, between injection and result, only the 1st time you use it, while next injection will be much faster, as I enabled connection persistance in the ssh config file.
