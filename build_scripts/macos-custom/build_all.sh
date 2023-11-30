#!/bin/sh

. ./config.sh

ARCH=`uname -m`

mkdir -p $BUILD_LIB_DIR
mkdir -p $BUILD_INCLUDE_DIR
mkdir -p $SOURCE_DIR

mkdir -p $DIST_LIB_DIR
mkdir -p $DIST_INCLUDE_DIR

case $ARCH in
	arm64)
		./build_openssl_arm64.sh
		./build_boost_arm64.sh;;
	x86_64)
		./build_openssl_x86_64.sh
		./build_boost_x86_64.sh;;
esac

./build_zmq.sh
./build_expat.sh
./build_unbound.sh
./build_sodium.sh
./build_monero.sh

./setup.sh