#!/bin/sh

. ./config.sh

OPEN_SSL_URL="https://github.com/x2on/OpenSSL-for-iPhone.git"
OPEN_SSL_DIR_PATH="${SOURCE_DIR}/OpenSSL"

echo "============================ OpenSSL ============================"

echo "Cloning Open SSL from - $OPEN_SSL_URL"
git clone $OPEN_SSL_URL $OPEN_SSL_DIR_PATH
cd $OPEN_SSL_DIR_PATH
./build-libssl.sh --version=1.1.1q --targets="ios-cross-arm64" --deprecated

cp -R ${OPEN_SSL_DIR_PATH}/include/* $BUILD_INCLUDE_DIR
cp ${OPEN_SSL_DIR_PATH}/lib/libcrypto-iOS.a ${BUILD_LIB_DIR}/libcrypto.a
cp ${OPEN_SSL_DIR_PATH}/lib/libssl-iOS.a ${BUILD_LIB_DIR}/libssl.a