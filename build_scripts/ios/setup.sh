#!/bin/sh

. ./config.sh

cd $BUILD_LIB_DIR

libtool -static -o libboost.a ./libboost_*.a
libtool -static -o libmonero.a ./monero/*.a

cp ./libboost.a ${DIST_LIB_DIR}
cp ./libcrypto.a ${DIST_LIB_DIR}
cp ./libssl.a ${DIST_LIB_DIR}
cp ./libsodium.a ${DIST_LIB_DIR}
cp ./libunbound.a ${DIST_LIB_DIR}
cp ./libzmq.a ${DIST_LIB_DIR}
cp ./libmonero.a $DIST_LIB_DIR
cp ${BUILD_INCLUDE_DIR}/monero/* $DIST_INCLUDE_DIR