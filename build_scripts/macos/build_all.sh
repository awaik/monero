#!/bin/sh

export SCRIPTS_DIR=`pwd`

HOST_NCORES=$(nproc 2>/dev/null || shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile

cd $SCRIPTS_DIR

cd ~
curl -O https://www.nlnetlabs.nl/downloads/unbound/unbound-1.17.0.tar.gz
tar -xvzf unbound-1.17.0.tar.gz
cd unbound-1.17.0
./configure
make
sudo make install

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
make release-static -j$HOST_NCORES