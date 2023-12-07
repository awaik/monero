#!/bin/bash

. ./config.sh

MONEROFFI_SRC_DIR=${BUILD_DIR}/monero-ffi

mkdir -p $MONEROFFI_SRC_DIR
cd $MONEROFFI_SRC_DIR
rsync -aP --exclude=build_scripts ${SCRIPTS_DIR}/../../ ${MONEROFFI_SRC_DIR}/

for arch in "aarch" "aarch64" "i686" "x86_64"
do
FLAGS=""
BUILD_ARCH_DIR=${BUILD_DIR}/prefix_${arch}
DEST_LIB_DIR=${BUILD_ARCH_DIR}/lib/monero-ffi
DEST_INCLUDE_DIR=${BUILD_ARCH_DIR}/include/monero-ffi
export CMAKE_INCLUDE_PATH="${BUILD_ARCH_DIR}/include"
export CMAKE_LIBRARY_PATH="${BUILD_ARCH_DIR}/lib"
ANDROID_STANDALONE_TOOLCHAIN_PATH="${TOOLCHAIN_BASE_DIR}_${arch}"
PATH="${ANDROID_STANDALONE_TOOLCHAIN_PATH}/bin:${ORIGINAL_PATH}"

mkdir -p $DEST_LIB_DIR
mkdir -p $DEST_INCLUDE_DIR

case $arch in
	"aarch"	)
		CLANG=arm-linux-androideabi-clang
 		CXXLANG=arm-linux-androideabi-clang++
		BUILD_64=OFF
		TAG="android-armv7"
		ARCH="armv7-a"
		ARCH_ABI="armeabi-v7a"
		FLAGS="-D CMAKE_ANDROID_ARM_MODE=ON -D NO_AES=true";;
	"aarch64"	)
		CLANG=aarch64-linux-androideabi-clang
 		CXXLANG=aarch64-linux-androideabi-clang++
		BUILD_64=ON
		TAG="android-armv8"
		ARCH="armv8-a"
		ARCH_ABI="arm64-v8a";;
	"i686"		)
		CLANG=i686-linux-androideabi-clang
 		CXXLANG=i686-linux-androideabi-clang++
		BUILD_64=OFF
		TAG="android-x86"
		ARCH="i686"
		ARCH_ABI="x86";;
	"x86_64"	)  
		CLANG=x86_64-linux-androideabi-clang
 		CXXLANG=x86_64-linux-androideabi-clang++
		BUILD_64=ON
		TAG="android-x86_64"
		ARCH="x86-64"
		ARCH_ABI="x86_64";;
esac

cd $MONEROFFI_SRC_DIR
rm -rf ./build/release
mkdir -p ./build/release
cd ./build/release
CC=${CLANG} CXX=${CXXLANG} cmake -D USE_DEVICE_TREZOR=OFF -D BUILD_GUI_DEPS=1 -D BUILD_TESTS=OFF -D ARCH=${ARCH} -D STATIC=ON -D BUILD_64=${BUILD_64} -D CMAKE_BUILD_TYPE=release -D ANDROID=true -D INSTALL_VENDORED_LIBUNBOUND=ON -D BUILD_TAG=${TAG} -D CMAKE_SYSTEM_NAME="Android" -D CMAKE_ANDROID_STANDALONE_TOOLCHAIN="${ANDROID_STANDALONE_TOOLCHAIN_PATH}" -D CMAKE_ANDROID_ARCH_ABI=${ARCH_ABI} $FLAGS ../..
    
make -j$THREADS

cp -r ./*.so $DEST_LIB_DIR
cp ../../src/monero_ffi.hpp $DEST_INCLUDE_DIR
done
