# sudo docker run -d -p 7075:7075/udp -p 7075:7075 -p 127.0.0.1:7076:7076 -v host_appdata_folder:/root brianpugh/rai_node
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget \
        git \
        autotools-dev \
        build-essential \
        cmake \
        g++ \
        python-dev \
        libicu-dev \
        libbz2-dev

ENV BOOST_ROOT=$HOME/opt/boost_1_63_0 \
    BOOST_URL=http://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.gz/download \
    BOOST_BUILD=$HOME/opt/boost_1_63_0.BUILD \
    RAIBLOCKS_GIT=https://github.com/clemahieu/raiblocks.git

WORKDIR /root

RUN wget -O boost_1_63_0.tar.gz ${BOOST_URL} && \
    tar xzf boost_1_63_0.tar.gz && \
    cd boost_1_63_0 && \
    ./bootstrap.sh --prefix=${BOOST_ROOT} && \
    ./b2 --prefix=$BOOST_ROOT --build-dir=$BOOST_BUILD link=static install && \
    cd $HOME && \
    git clone --recursive $RAIBLOCKS_GIT && \
    cd raiblocks && \
    sed -i 's/-msse4/-msse3/g' CMakeLists.txt && \
    cmake . && \
    make rai_node

EXPOSE 7075 7076

ENTRYPOINT ./raiblocks/rai_node --daemon
