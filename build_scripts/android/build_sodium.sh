#!/bin/bash

. ./config.sh
SODIUM_SRC_DIR=${BUILD_DIR}/libsodium
SODIUM_BRANCH=1.0.16

for arch in "aarch" "aarch64" "i686" "x86_64"
do

BUILD_ARCH_DIR=${BUILD_DIR}/prefix_${arch}
PATH="${TOOLCHAIN_BASE_DIR}_${arch}/bin:${ORIGINAL_PATH}"

case $arch in
	"aarch"	) TARGET="arm";;
	"i686"		) TARGET="x86";;
	*		) TARGET="${arch}";;
esac  

HOST="${TARGET}-linux-android"
cd $BUILD_DIR
rm -rf $SODIUM_SRC_DIR
git clone https://github.com/jedisct1/libsodium.git $SODIUM_SRC_DIR -b $SODIUM_BRANCH
cd $SODIUM_SRC_DIR
./autogen.sh
CC=clang CXX=clang++ ./configure --prefix=${BUILD_ARCH_DIR} --host=${HOST} --enable-static --disable-shared
make -j$THREADS
make install

done

