# raiblocks-docker
A Dockerfile that will build RaiBlocks from source

# Standard Configuration:
For the majority of users, you can run this docker by using the following
command:
```
docker run -d \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh/rai_node
```

Where <HOST_FOLDER> is where you want the ledger and config files to be stored
on the host OS. Note that the 127.0.0.1 portion of the command only allows the
host computer to issue RPC commands. Remove the 127.0.0.1 only if you want
remote RDP access and you have proper firewalls and other network configurations
in place.

After the initial run, the ldb file and config.json will be in <HOST_FOLDER>.
You can now kill the instance, configure the config.json to do things like:

## Enable RPC:
To enable RPC commands, edit the following in <HOST_FOLDER>/config.json after
running (and killing) the docker image at least once. Leave the port to the
default 7076, if you want a different port on the host, change that in the
command you use to spin up the docker instance.
* Set ``"rpc_enable": "true",``
* Set ``"enable_control": "true",``
* Set ``"address":"::ffff:0.0.0.0",``

## Enable Callbacks
Callbacks is where the rai_node sends a POST command for every incoming block.
Note that if you enable callbacks you have to also forward the port in the
docker container to the host while starting an instance, i.e ``-p 17076:17076``.

For typical local operations, <IP>=127.0.0.1 and <PORT>=17076 are good defaults:
* Set "callback_address": "<IP>",
* Set "callback_port": "<PORT>",

## Enable OpenCL for systems with GPUs:
* Set "opencl_enable":"true",
* Changing the other opencl options are unnecessary, only change if you really
know what you are doing.

# Customizing the Dockerfile
You can edit the Dockerfile to change which git branch you use by changing the
XRB_BRANCH environmental variable to the branch name you would like to use.

To subsequently build your new dockerfile, you can call
    docker build -t "brianpugh:rai_node_custom" .

To then spin up an instance of this newly build docker, you can call
```
docker run -d \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh:rai_node_custom
```

# Issuing CLI commands
Currently, some items like ``wallet_id`` cannot be queried via RPC commands and
must be queried via command line arguments. The best way to do this is to start
an instance of this docker with a shell overide:
```
docker run -it \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh/rai_node /bin/sh
```
From here you can issue CLI commands; for example:
    ./rai_node --wallet-list

Once you are done with your CLI commands, exit the docker image with
``exit``.

You can then start the docker command again with the standard:
```
docker run -d \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh/rai_node
```

# Stopping An Instance
To stop a running instance, you can issue the command:
    docker stop brianpugh/rai_node
In general, to list all running docker instances, issue the command:
    docker ps
In general, to stop a specific instance, issue the command:
    docker stop <container_id or container_name>
