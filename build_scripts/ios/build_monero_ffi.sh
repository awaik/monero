#!/bin/sh

. ./config.sh

MONEROFFI_DIR_PATH="${SOURCE_DIR}/monero-ffi"
BUILD_TYPE=release

echo "Copy monero to $MONEROFFI_DIR_PATH"
mkdir -p $MONEROFFI_DIR_PATH
cd $MONEROFFI_DIR_PATH
rsync -aP --exclude=build_scripts $SCRIPTS_DIR/../../ ${MONEROFFI_DIR_PATH}/
mkdir -p build
cd ..

for arch in "arm64" #"armv7" "arm64"
do

echo "Building IOS ${arch}"
export CMAKE_INCLUDE_PATH=${BUILD_INCLUDE_DIR}
export CMAKE_LIBRARY_PATH=${BUILD_LIB_DIR}

case $arch in
	"armv7"	)
		DEST_LIB=../../lib-armv7;;
	"arm64"	)
		DEST_LIB=../../lib-armv8-a;;
esac

rm -r $MONEROFFI_DIR_PATH/build > /dev/null

mkdir -p $MONEROFFI_DIR_PATH/build/${BUILD_TYPE}
pushd $MONEROFFI_DIR_PATH/build/${BUILD_TYPE}

cmake -D IOS=ON \
	-DARCH=${arch} \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DSTATIC=ON \
	-DCMAKE_INSTALL_PREFIX=${BUILD_DIR}  \
	../..

make -j4

cp ./*.dylib ${BUILD_LIB_DIR}
cp ../../src/monero_ffi.h ${BUILD_INCLUDE_DIR}

popd

done
