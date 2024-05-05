#!/usr/bin/env bash
set -euo pipefail

# IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')
PORT=$(grep "^Port" /etc/ssh/sshd_config|cut -d\  -f 2)

#echo "Fixing container ssh config with detected IP: ${IP} and PORT: ${PORT}"
echo "Fixing container ssh config with detected PORT: ${PORT}"
# sed -i -e "s/Hostname.*/Hostname ${IP}/" ssh/config
sed -i -e "s/Port.*/Port ${PORT}/" ssh/config

echo "Generating ssh keys and adding them to host authorized_keys file"
ssh-keygen -f ssh/id_nr -t ed25519 -q -N ""
cat ssh/id_nr.pub >> "$HOME"/.ssh/authorized_keys

echo "Assuring data, ssh and dbs folders and their content are owned by 1000:1000"
chown -R 1000:1000 data ssh ../dbs

echo "Starting Node-RED container"
docker compose up -d

echo "Testing ssh connection from container to host."
echo "You should see the HOST release file content below:"
docker compose exec nodered /bin/bash -c "ssh host cat /etc/*rele*"
