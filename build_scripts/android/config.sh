#!/bin/bash

export API=21
export SCRIPTS_DIR=`pwd`
export BUILD_DIR=${SCRIPTS_DIR}/build
export DIST_DIR=${SCRIPTS_DIR}/dist

export ANDROID_NDK_ZIP=${BUILD_DIR}/android-ndk-r17c.zip
export ANDROID_NDK_ROOT=${BUILD_DIR}/android-ndk-r17c
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT
export TOOLCHAIN_DIR="${BUILD_DIR}/toolchain"
export TOOLCHAIN_BASE_DIR=$TOOLCHAIN_DIR
export ORIGINAL_PATH=$PATH
export THREADS=4
