#!/bin/sh

ARCH=$1
BUILD_ARCH_DIR=$2
BOOST_SRC_DIR=$3

cd $BOOST_SRC_DIR

./b2 --build-type=minimal link=static runtime-link=static --with-chrono --with-date_time --with-filesystem --with-program_options --with-regex --with-serialization --with-system --with-thread --with-locale --build-dir=android --stagedir=android toolset=clang threading=multi threadapi=pthread target-os=android -sICONV_PATH=${BUILD_ARCH_DIR} -j$THREADS install
