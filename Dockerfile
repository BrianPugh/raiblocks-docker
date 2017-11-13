# sudo docker run -d -p 7075:7075/udp -p 7075:7075 -p 127.0.0.1:7076:7076 -v host_appdata_folder:/root brianpugh/rai_node
# Change this to something lighter weight later
FROM ubuntu:latest # Change this to something lighter weight later

ENV RAIBLOCKS_URL=https://github.com/clemahieu/raiblocks/releases/download/V8.0/rai_node.xz

WORKDIR /root

RUN wget ${RAIBLOCKS_URL} && \
    tar xf rai_node.xz && \

EXPOSE 7075 7076

ENTRYPOINT ./rai_node --daemon

CMD ["--restricted-rpc", "--rpc-bind-ip=127.0.0.1", "--confirm-external-bind"]
