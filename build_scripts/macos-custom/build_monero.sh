#!/bin/sh

. ./config.sh

MONERO_DIR_PATH="${SOURCE_DIR}/monero"
BUILD_TYPE=release
PREFIX=${BUILD_DIR}
DEST_LIB_DIR=${BUILD_LIB_DIR}/monero
DEST_INCLUDE_DIR=${BUILD_INCLUDE_DIR}/monero
ARCH=`uname -m`

echo "Copy sources from to - $MONERO_DIR_PATH"
mkdir -p $MONERO_DIR_PATH
cd $MONERO_DIR_PATH
rsync -aP --exclude=build_scripts ${MONERO_DIR_PATH}/../../../../../ ${MONERO_DIR_PATH}/
mkdir -p build
cd ..

mkdir -p $DEST_LIB_DIR
mkdir -p $DEST_INCLUDE_DIR

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $INSTALL_PREFIX ]; then
    INSTALL_PREFIX=${ROOT_DIR}/monero
fi

echo "Building MACOS ${ARCH}"
export CMAKE_INCLUDE_PATH="${PREFIX}/include"
export CMAKE_LIBRARY_PATH="${PREFIX}/lib"
rm -r monero/build > /dev/null

if [ "${ARCH}" == "x86_64" ]; then
	ARCH="x86-64"
fi

mkdir -p monero/build/${BUILD_TYPE}
pushd monero/build/${BUILD_TYPE}
cmake --debug-output \
	-DARCH=${ARCH} \
	-DBUILD_64=ON \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DSTATIC=ON \
	-DBUILD_GUI_DEPS=ON \
	-DUNBOUND_INCLUDE_DIR=${BUILD_INCLUDE_DIR} \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}  \
    -DUSE_DEVICE_TREZOR=OFF \
	../..
make wallet_api -j4
find . -path ./lib -prune -o -name '*.a' -exec cp '{}' lib \;
cp -r ./lib/* $DEST_LIB_DIR
cp ../../src/wallet/api/wallet2_api.h  $DEST_INCLUDE_DIR
popd
