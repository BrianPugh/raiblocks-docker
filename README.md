# raiblocks-docker
A Dockerfile that will build RaiBlocks from source. WARNING: GPU branch is untested, probably doesn't work, and is a work in progress.

# Standard Configuration:
For the majority of users, you can run this docker by using the following
command:
```
docker run --restart unless-stopped -d \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh/raiblocks-docker
```

Where <HOST_FOLDER> is where you want the ledger and config files to be stored
on the host OS. Note that the 127.0.0.1 portion of the command only allows the
host computer to issue RPC commands. Remove the 127.0.0.1 only if you want
remote RDP access and you have proper firewalls and other network configurations
in place.

After the initial run, the ldb file and config.json will be in <HOST_FOLDER>.
You can now stop the instance, configure the config.json to do things like.
You probably wont even have to stop it, it'll probably hit the following error
and stop itself:
    Error while running node (Cannot assign requested address)

## Enable RPC:
To enable RPC commands, edit the following in <HOST_FOLDER>/config.json after
running (and killing) the docker image at least once. Leave the port to the
default 7076, if you want a different port on the host, change that in the
command you use to spin up the docker instance.
* Set ``"rpc_enable": "true",``
* Set ``"enable_control": "true",``
* Set ``"address":"::ffff:0.0.0.0",``

You can test the RPC by issueing POST commands, for example:
```curl -d '{"action":"block_count"}' 127.0.01:7076```

## Enable Callbacks
Callbacks is where the rai_node sends a POST command for every incoming block.

For typical local operations, ``<IP>=127.0.0.1`` and ``<PORT>=17076`` are good defaults:
* Set ``"callback_address": "<IP>",``
* Set ``"callback_port": "<PORT>",``

## Enable OpenCL for systems with GPUs:
* Set ``"opencl_enable":"true",``
* Changing the other opencl options are unnecessary, only change if you really
know what you are doing.

# Customizing the Dockerfile
You can edit the Dockerfile to change which git branch you use by changing the
XRB_BRANCH environmental variable to the branch name you would like to use.

To subsequently build your new dockerfile, you can call
```docker build -t "brianpugh:rai_node_custom" .```

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
must be queried via command line arguments. You can issue CLI commands while
the docker instance is running. First find your docker instance's container_id
via ``docker ps``.

Then commands can be issued:
```
docker exec <CONTAINER_ID> /rai_node <command_parameters>
```
Common commands would be:

## Cleaning up the local database (reduces size and disk I/O)

```
docker exec <CONTAINER_ID> /rai_node --vacuum
```

## Finding Wallet ID's and Addresses
```
docker exec <CONTAINER_ID> /rai_node --wallet_list
```

## Backing Up Seed
```
docker exec <CONTAINER_ID> /rai_node --wallet_decrypt_unsafe --wallet <WALLET_ID>
```

# Stopping An Instance
In general, to list all running docker instances, issue the command:
```docker ps```
In general, to stop a specific instance, issue the command:
```docker stop <container_id or container_name>```

# Automatic Updating
This docker container automatically builds from the RaiBlocks Master git branch within 2 hours whenever there is a new commit. Your local docker instance, however, only updates when told to. You can also have your local container restart and update whenever this docker container is updated via another docker container like [watchtower](https://github.com/v2tec/watchtower).
