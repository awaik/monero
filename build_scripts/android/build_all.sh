#!/bin/bash

. ./config.sh

mkdir -p $BUILD_DIR
mkdir -p $DIST_DIR

./install_ndk.sh
./build_iconv.sh
./build_boost.sh
./build_openssl.sh
./build_sodium.sh
./build_unbound.sh
./build_zmq.sh
./build_monero.sh
./build_monero_ffi.sh

./copy_monero_deps.sh