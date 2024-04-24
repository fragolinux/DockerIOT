# MOSQUITTO SETUP

create the hashed passwd file (change username and password in last bits of next command) running this from current folder:

    docker run -it --rm \
      -v $PWD/data/config:/mosquitto/config \
      -v $PWD/data/data:/mosquitto/data \
      -v $PWD/data/log:/mosquitto/log \
      eclipse-mosquitto mosquitto_passwd -b \
      -c /mosquitto/config/passwd username password
