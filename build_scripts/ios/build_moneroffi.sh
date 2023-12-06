#!/bin/sh

. ./config.sh

MONEROFFI_DIR_PATH="${SOURCE_DIR}/moneroffi"
BUILD_TYPE=release
DEST_LIB_DIR=${BUILD_LIB_DIR}/moneroffi
DEST_INCLUDE_DIR=${BUILD_INCLUDE_DIR}/moneroffi

echo "Copy monero to $MONEROFFI_DIR_PATH"
mkdir -p $MONEROFFI_DIR_PATH
cd $MONEROFFI_DIR_PATH
rsync -aP --exclude=build_scripts $SCRIPTS_DIR/../../ ${MONEROFFI_DIR_PATH}/
mkdir -p build
cd ..

mkdir -p $DEST_LIB_DIR
mkdir -p $DEST_INCLUDE_DIR

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

make -j4 -d
#find . -path ./lib -prune -o -name '*.a' -exec cp '{}' lib \;
#cp -R ./lib/* $DEST_LIB_DIR
#cp ../../src/wallet/api/wallet2_api.h  $DEST_INCLUDE_DIR
popd

done
