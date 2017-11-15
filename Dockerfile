# sudo docker run -d -p 7075:7075/udp -p 7075:7075 -p 127.0.0.1:7076:7076 -v host_appdata_folder:/root brianpugh/rai_node
# Change this to something lighter weight later
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget \
        autotools-dev \
        build-essential \
        g++ \
        python-dev \
        libicu-dev \
        libbz2-dev

ENV RAIBLOCKS_URL=https://github.com/clemahieu/raiblocks/releases/download/V8.0/rai_node.xz \
    BOOST_ROOT=$HOME/opt/boost_1_63_0 \
    BOOST_URL=http://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.gz/download \
    BOOST_BUILD=$HOME/opt/boost_1_63_0.BUILD

WORKDIR /root

RUN wget -O boost_1_63_0.tar.gz ${BOOST_URL} && \
    tar xzf boost_1_63_0.tar.gz && \
    cd boost_1_63_0 && \
    ./bootstrap.sh --prefix=${BOOST_ROOT} && \
    ./b2 --prefix=$BOOST_ROOT --build-dir=$BOOST_BUILD link=static install && \
    git clone https://github.com/clemahieu/raiblocks.git && \
    cd raiblocks && \
    make rai_node

EXPOSE 7075 7076

ENTRYPOINT ./rai_node --daemon
