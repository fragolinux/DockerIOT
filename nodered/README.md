# NODERED SETUP

set timezone in `.env` file, then change ownership to the data folder:

    chown -R 1000:1000 data

## OPTIONAL: to allow access to host devices, like serial ports, or bluetooth, or whatever

check the device id you want to pass through to the container:

    ls /dev/serial/by-id

then set this device in `.env` file, uncomment the 4 lines you see in the `docker-compose.yml` file, and restart container

## OPTIONAL: to add EXEC permission on the host... BEWARE, HIGHLY INSECURE if nodered exposed to public and not well protected, the ssh keypair that will be used will allow FULL ROOT ACCESS to the underlying HOST OS!!!
## OPTIONAL: to allow access to host devices, like serial ports, or bluetooth, or whatever

shutdown nodered container, then edit its `docker-compose.yml`, add this to the `volumes` section (respect indentation, it should be at same level as the other line about "data" folder):

    - ./ssh:/usr/src/node-red/.ssh

create the folder that will contain the ssh keypair needed for nodered to access the host system without a password:

    mkdir -p /root/DockerIOT/nodered/ssh
    chown -R 1000:1000 /root/DockerIOT/nodered/ssh
    cd /root/DockerIOT/nodered
    dstart # if not working, apply my aliases on main readme in my repo
    dbash # if not working, apply my aliases on main readme in my repo

now you're INSIDE the nodered docker container... generate an ssh keypair, with no passphrase:

    ssh-keygen -f /usr/src/node-red/.ssh/id_nr -t ed25519 -q -N ""

copy the public key into the HOST system's authorized_keys, change the ssh port if needed (default 22) and ip address, and provide the HOST root password when asked:

    ssh-copy-id -i /usr/src/node-red/.ssh/id_nr -o "StrictHostKeyChecking=accept-new" -p 22 root@192.168.1.X

try that ssh from container to host now works, without any password request, again change the ssh port if needed (default 22) and ip address:

    ssh -i /usr/src/node-red/.ssh/id_nr -o "StrictHostKeyChecking=accept-new" -p 22 root@192.168.1.X

type exit to close the ssh session, exit again to close the shell inside the container.

Sample flow showing how to run commands on the host: you NEED to set the port (if not default 22) and ip address, then the COMMAND text box will ALWAYS be the same, while you need to add the command you want to exec on the host in the second text box of the node, the one between "append" and "output" (`ls /root/DockerIOT` in this example):

    [
        {
            "id": "365e3bba8d3fb277",
            "type": "inject",
            "z": "1b1395421945f1a2",
            "name": "",
            "props": [
                {
                    "p": "payload"
                },
                {
                    "p": "topic",
                    "vt": "str"
                }
            ],
            "repeat": "",
            "crontab": "",
            "once": false,
            "onceDelay": 0.1,
            "topic": "",
            "payload": "",
            "payloadType": "date",
            "x": 320,
            "y": 320,
            "wires": [
                [
                    "d889a35bfcc63c2f"
                ]
            ]
        },
        {
            "id": "d889a35bfcc63c2f",
            "type": "exec",
            "z": "1b1395421945f1a2",
            "command": "ssh -i /usr/src/node-red/.ssh/id_nr -o \"StrictHostKeyChecking=accept-new\" -p 22 root@192.168.1.X",
            "addpay": "",
            "append": "ls /root/DockerIOT",
            "useSpawn": "false",
            "timer": "",
            "winHide": false,
            "oldrc": false,
            "name": "SSH-HOST",
            "x": 550,
            "y": 320,
            "wires": [
                [
                    "2bbd7f95a746914a"
                ],
                [],
                []
            ]
        },
        {
            "id": "2bbd7f95a746914a",
            "type": "debug",
            "z": "1b1395421945f1a2",
            "name": "debug 1",
            "active": true,
            "tosidebar": true,
            "console": false,
            "tostatus": false,
            "complete": "false",
            "statusVal": "",
            "statusType": "auto",
            "x": 760,
            "y": 320,
            "wires": []
        }
    ]

inject a timestamp, you'll get the content of that folder in the debug node, there will be a little delay, about 1 second, between injection and result
