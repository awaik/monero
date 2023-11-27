#!/bin/sh

export SCRIPTS_DIR=`pwd`

HOST_NCORES=$(nproc 2>/dev/null || shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile

echo "***************"
echo "*** libexpat ***"
echo "***************"

cd ~
curl -O https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.bz2
tar -xf expat-2.4.8.tar.bz2
cd expat-2.4.8
./configure --enable-static --disable-shared
make
sudo make install

echo "***************"
echo "*** unbound ***"
echo "***************"

cd ~
curl -O https://www.nlnetlabs.nl/downloads/unbound/unbound-1.17.0.tar.gz
tar -xvzf unbound-1.17.0.tar.gz
cd unbound-1.17.0
./configure --with-libexpat=~/expat-2.4.8
make
sudo make install

echo "***************"
echo "*** monero-cpp ***"
echo "***************"

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
make release-static -j$HOST_NCORES