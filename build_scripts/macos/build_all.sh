#!/bin/sh

export SCRIPTS_DIR=`pwd`

HOST_NCORES=$(nproc 2>/dev/null || shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)

cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile

echo "***************"
echo "*** unbound ***"
echo "***************"

#cd ~
cd $SCRIPTS_DIR
curl -O https://www.nlnetlabs.nl/downloads/unbound/unbound-1.17.0.tar.gz
tar -xvzf unbound-1.17.0.tar.gz
cd unbound-1.17.0
./configure --with-ssl=/usr/local/opt/openssl --with-libexpat=/usr/local/opt/expat
make -j$HOST_NCORES
sudo make install


echo "**************"
echo "*** monero ***"
echo "**************"


cd $SCRIPTS_DIR
cd ../../external/monero-cpp/external/monero-project
make release-static -j$HOST_NCORES

echo "******************"
echo "*** monero-cpp ***"
echo "******************"

cd $SCRIPTS_DIR
./bin/build_libmonero_cpp.sh

