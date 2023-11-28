#!/bin/sh

. ./config.sh

MONERO_DIR_PATH="${SOURCE_DIR}/monero"
BUILD_TYPE=release
DEST_LIB_DIR=${BUILD_LIB_DIR}/monero
DEST_INCLUDE_DIR=${BUILD_INCLUDE_DIR}/monero

echo "Copy monero to $MONERO_DIR_PATH"
mkdir -p $MONERO_DIR_PATH
cd $MONERO_DIR_PATH
rsync -aP --exclude=build_scripts $SCRIPTS_DIR/../../external/monero-cpp/external/monero-project/ ${MONERO_DIR_PATH}/
mkdir -p build
cd ..

mkdir -p $DEST_LIB_DIR
mkdir -p $DEST_INCLUDE_DIR

for arch in "arm64" #"armv7" "arm64"
do

echo "Building IOS ${arch}"
export CMAKE_INCLUDE_PATH=${BUILD_INCLUDE_DIR}
export CMAKE_LIBRARY_PATH=${BUILD_LIB_DIR}

case $arch in
	"armv7"	)
		DEST_LIB=../../lib-armv7;;
	"arm64"	)
		DEST_LIB=../../lib-armv8-a;;
esac

rm -r monero/build > /dev/null

mkdir -p monero/build/${BUILD_TYPE}
pushd monero/build/${BUILD_TYPE}
cmake -D IOS=ON \
	-DARCH=${arch} \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DSTATIC=ON \
	-DBUILD_GUI_DEPS=ON \
	-DUNBOUND_INCLUDE_DIR=${BUILD_INCLUDE_DIR} \
	-DCMAKE_INSTALL_PREFIX=${BUILD_DIR}  \
    -DUSE_DEVICE_TREZOR=OFF \
	../..
make wallet_api -j4
find . -path ./lib -prune -o -name '*.a' -exec cp '{}' lib \;
cp -R ./lib/* $DEST_LIB_DIR
cp ../../src/wallet/api/wallet2_api.h  $DEST_INCLUDE_DIR
popd

done
