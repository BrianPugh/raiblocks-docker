FROM alpine:3.7
LABEL maintainer="Brian Pugh <bnp117@gmail.com>"

# Install some standard packages
RUN apk add --update --no-cache \
     build-base \
     cmake \
     g++ \
     git \
     linux-headers \
     wget

# Easy configurable values; if you want these values to impact the docker image,
# you must edit these values and build
ENV XRB_BRANCH=master \
    XRB_URL=https://github.com/clemahieu/raiblocks.git \
    BOOST_URL=http://sourceforge.net/projects/boost/files/boost/1.66.0/boost_1_66_0.tar.gz/download

WORKDIR /

# Download and install boost
RUN wget -O boost.tar.gz ${BOOST_URL} \
    && mkdir boost \
    && tar xzf boost.tar.gz -C boost --strip-components 1 \
    && rm boost.tar.gz \
    && cd boost \
    && ./bootstrap.sh \
    && ./b2 --prefix=/[boost] link=static install; exit 0 \
    && cd .. && rm -rf boost

# Clone the RaiBlocks git, change branch, and build
RUN git clone ${XRB_URL} raiblocks \
    && cd raiblocks \
    && git checkout ${XRB_BRANCH} \
    && git submodule init \
    && git submodule update \
    && mkdir build \
    && cd build \
    && cmake -DBOOST_ROOT=/[boost] -G "Unix Makefiles" .. \
    && make rai_node \
    && mv rai_node / \
    && cd / && rm -rf raiblocks

EXPOSE 7075 7075/udp 7076

CMD ["/rai_node", "--daemon"]
