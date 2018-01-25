#!/bin/bash
# Default configuation as described in the Dockerfile
sudo docker run -d \
    -p 7075:7075/udp \
    -p 7075:7075 \
    -p 127.0.0.1:7076:7076 \
    -v <HOST_FOLDER>:/root/RaiBlocks \
    brianpugh/rai_node

