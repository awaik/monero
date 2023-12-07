#!/bin/bash

. ./config.sh

export ICONV_FILENAME=libiconv-1.16.tar.gz
export ICONV_FILE_PATH=$BUILD_DIR/$ICONV_FILENAME
export ICONV_SRC_DIR=$BUILD_DIR/libiconv-1.16
ICONV_SHA256="e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04"

curl http://ftp.gnu.org/pub/gnu/libiconv/$ICONV_FILENAME -o $ICONV_FILE_PATH
echo $ICONV_SHA256 $ICONV_FILE_PATH | sha256sum -c - || exit 1

for arch in aarch aarch64 i686 x86_64
do

BUILD_ARCH_DIR=${BUILD_DIR}/prefix_${arch}
PATH="${TOOLCHAIN_BASE_DIR}_${arch}/bin:${ORIGINAL_PATH}"

case $arch in
	"aarch"	)
		CLANG=arm-linux-androideabi-clang
        CXXLANG=arm-linux-androideabi-clang++
        HOST="arm-linux-android";;
	*		)
		CLANG=${arch}-linux-android-clang
		CXXLANG=${arch}-linux-android-clang++
		HOST="${arch}-linux-android";;
esac 

cd $BUILD_DIR
rm -rf $ICONV_SRC_DIR
tar -xzf $ICONV_FILE_PATH -C $BUILD_DIR
cd $ICONV_SRC_DIR
CC=${CLANG} CXX=${CXXLANG} ./configure --build=x86_64-linux-gnu --host=${HOST} --prefix=${BUILD_ARCH_DIR} --disable-rpath
make -j$THREADS
make install

done

