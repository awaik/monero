#!/bin/sh

. ./config.sh

#./prepare_system.sh

./make_dirs.sh

cd $SCRIPTS_DIR

./install_missing_headers.sh
./build_openssl.sh
./build_boost.sh
./build_sodium.sh
./build_zmq.sh
./build_unbound.sh
./build_monero.sh

./setup.sh