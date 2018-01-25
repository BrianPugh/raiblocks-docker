# For a standard local configuration run this docker:
#    sudo docker run -d \
#		 -p 7075:7075/udp \
# 		 -p 7075:7075 \
#		 -p 127.0.0.1:7076:7076 \
#  		 -v <HOST_FOLDER>:/root/RaiBlocks \
#        brianpugh/rai_node
#
# Where <HOST_FOLDER> is where you want the ledger and config files to be stored
# on the host OS. Note that the 127.0.0.1 portion of the command only allows the
# host computer to issue RPC commands. Remove the 127.0.0.1 only if you want
# remote access and have proper firewalls and other network configurations in
# place.
#
# You can change the git branch to use via setting:
#        -e XRB_BRANCH='branch name whatever it may be'
#
# After the initial run, the ldb file and config.json will be in <HOST_FOLDER>.
# You can now kill the instance, configure the config.json to do things like:
#	Enable RPC:
#		* Set "rpc_enable": "true",
#       * Set "enable_control": "true",
#   Enable Callbacks (where the rai_node sends a POST command for every
#   incoming block). Note that if you enable callbacks you have to also
#   forward the port in the docker container to the host using the "-p"
#   option used in the example at the beginning of this document. For typical
#   local operations, <IP>=127.0.0.1 and <PORT>=17076 are good defaults:
#       * Set "callback_address": "<IP>",
#       * Set "callback_port": "<PORT>",
#   Manually sync by overwriting the ldb file
#       * See online tutorials on how to do this; note you must restore or
#		  change your seed after doing this.
#   Enable OpenCL for systems with GPUs:
#       * Set "opencl_enable":"true",
#       * Changing the other opencl options are unnecessary, only change if you
#         really know what you are doing.
#
# If you need to issue CLI commands, for example:
#     ./rai_node --wallet-list

FROM ubuntu:16.04
LABEL maintainer="Brian Pugh"

RUN apt-get update && yes | apt-get install \
    g++ \
	 cmake \
	 git \
	python \
     wget

# Easy configurable values
ENV BOOST_VER=66 \
	XRB_BRANCH=master \
    XRB_URL=https://github.com/clemahieu/raiblocks.git

# Should automatically generate, probably don't touch these
ENV BOOST_URL=http://sourceforge.net/projects/boost/files/boost/1.${BOOST_VER}.0/boost_1_${BOOST_VER}_0.tar.gz/download

WORKDIR /
# Get and install boost
RUN wget -O boost.tar.gz ${BOOST_URL} && \
    mkdir boost && \
    tar xzf boost.tar.gz -C boost --strip-components 1 && \
    rm boost.tar.gz && \
    cd boost && \
    ./bootstrap.sh && \
    ./b2 --prefix=/[boost] link=static install; exit 0

# Clone the RaiBlocks git, change branch, and build
RUN git clone ${XRB_URL} raiblocks && \
    cd raiblocks && \
	git checkout ${XRB_BRANCH} && \
	git submodule init && \
	git submodule update && \
    mkdir build && \
    cd build && \
    cmake -DBOOST_ROOT=/[boost] -G "Unix Makefiles" .. && \
	make rai_node && \
    mv rai_node /

EXPOSE 7075 7075/udp 7076

CMD ["/rai_node", "--daemon"]
