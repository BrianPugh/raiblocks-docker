# sudo docker run -d -p 7075:7075/udp -p 7075:7075 -p 127.0.0.1:7076:7076 -v host_appdata_folder:/root/RaiBlocks brianpugh/rai_node
# Change this to something lighter weight later
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget \
    xz-utils \
    automake \
    libcurl4-openssl-dev \
    git \
    make \
    build-essential

WORKDIR /root

ENV RAIBLOCKS_URL=https://github.com/clemahieu/raiblocks/releases/download/V8.0/rai_node.xz

RUN wget ${RAIBLOCKS_URL} && \
    tar xf rai_node.xz

VOLUME /root/RaiBlocks

EXPOSE 7075 7076

ENTRYPOINT ./rai_node --daemon
