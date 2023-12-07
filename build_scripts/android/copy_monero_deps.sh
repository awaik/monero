#!/bin/bash

. ./config.sh

for arch in "aarch" "aarch64" "i686" "x86_64"
do

BUILD_ARCH_DIR=${BUILD_DIR}/prefix_${arch}
ABI=""

case $arch in
	"aarch"	)
		ABI="armeabi-v7a";;
	"aarch64"	)
		ABI="arm64-v8a";;
	"i686"		)
		ABI="x86";;
	"x86_64"	)
		ABI="x86_64";;
esac

DIST_LIB_DIR=${DIST_DIR}/${ABI}/lib
DIST_INCLUDE_DIR=${DIST_DIR}/${ABI}/include

mkdir -p $DIST_LIB_DIR
mkdir -p $DIST_INCLUDE_DIR

#cp -r ${BUILD_ARCH_DIR}/lib/monero-ffi/* $DIST_LIB_DIR
#cp -r ${BUILD_ARCH_DIR}/include/monero-ffi/* $DIST_INCLUDE_DIR

cp -r ${BUILD_ARCH_DIR}/lib/* $DIST_LIB_DIR
cp -r ${BUILD_ARCH_DIR}/include/monero-ffi/* $DIST_INCLUDE_DIR

done