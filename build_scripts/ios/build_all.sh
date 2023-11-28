#!/bin/sh

. ./config.sh

mkdir -p $SOURCE_DIR
mkdir -p $BUILD_LIB_DIR
mkdir -p $BUILD_INCLUDE_DIR

mkdir -p $DIST_LIB_DIR
mkdir -p $DIST_INCLUDE_DIR

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile
brew remove hidapi

cd $SCRIPTS_DIR

./install_missing_headers.sh
./build_openssl.sh
./build_boost.sh
./build_sodium.sh
./build_zmq.sh
./build_unbound.sh
./build_monero.sh

./setup.sh