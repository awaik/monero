#!/bin/sh

. ./config.sh

MIN_IOS_VERSION=10.0
BOOST_URL="https://github.com/cake-tech/Apple-Boost-BuildScript.git"
BOOST_DIR_PATH="${SOURCE_DIR}/Apple-Boost-BuildScript"
BOOST_VERSION=1.72.0
BOOST_LIBS="random regex graph random chrono thread filesystem system date_time locale serialization program_options"

echo "============================ Boost ============================"

echo "Cloning Apple-Boost-BuildScript from - $BOOST_URL"
git clone -b build $BOOST_URL $BOOST_DIR_PATH
cd $BOOST_DIR_PATH
./boost.sh -ios \
	--min-ios-version ${MIN_IOS_VERSION} \
	--boost-libs "${BOOST_LIBS}" \
	--boost-version ${BOOST_VERSION} \
	--no-framework

mv ${BOOST_DIR_PATH}/build/boost/${BOOST_VERSION}/ios/release/prefix/include/*  $BUILD_INCLUDE_DIR
mv ${BOOST_DIR_PATH}/build/boost/${BOOST_VERSION}/ios/release/prefix/lib/*  $BUILD_LIB_DIR