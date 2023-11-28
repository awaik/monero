#!/bin/sh

. ./config.sh

ZMQ_PATH="${SOURCE_DIR}/libzmq"
ZMQ_URL="https://github.com/zeromq/libzmq.git"

echo "============================ ZMQ ============================"

echo "Cloning ZMQ from - $ZMQ_URL"
git clone $ZMQ_URL $ZMQ_PATH
cd $ZMQ_PATH
./builds/ios/build_ios.sh

cp -R ${ZMQ_PATH}/builds/ios/libzmq_build/arm64/include/* $BUILD_INCLUDE_DIR
cp ${ZMQ_PATH}/builds/ios/libzmq_build/arm64/lib/libzmq.a $BUILD_LIB_DIR