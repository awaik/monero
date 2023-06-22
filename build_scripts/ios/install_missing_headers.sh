#!/bin/bash

. ./config.sh

echo "Installing missing headers"

# vmmeter
mkdir -p ${BUILD_INCLUDE_DIR}/sys

if [ ! -f ${BUILD_INCLUDE_DIR}/sys/vmmeter.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/vmmeter.h ${BUILD_INCLUDE_DIR}/sys/vmmeter.h
fi

# netinet
mkdir -p ${BUILD_INCLUDE_DIR}/netinet
if [ ! -f ${BUILD_INCLUDE_DIR}/netinet/ip_var.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/netinet/ip_var.h ${BUILD_INCLUDE_DIR}/netinet/ip_var.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/netinet/udp_var.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/netinet/udp_var.h ${BUILD_INCLUDE_DIR}/netinet/udp_var.h
fi

# IOKit
mkdir -p ${BUILD_INCLUDE_DIR}/IOKit
if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/IOTypes.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/IOTypes.h  ${BUILD_INCLUDE_DIR}/IOKit/IOTypes.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/IOMapTypes.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/IOMapTypes.h  ${BUILD_INCLUDE_DIR}/IOKit/IOMapTypes.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/IOKitLib.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/IOKitLib.h ${BUILD_INCLUDE_DIR}/IOKit/IOKitLib.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/IOReturn.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/IOReturn.h ${BUILD_INCLUDE_DIR}/IOKit/IOReturn.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/OSMessageNotification.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/OSMessageNotification.h  ${BUILD_INCLUDE_DIR}/IOKit/OSMessageNotification.h
fi

# IOKit/ps
mkdir -p ${BUILD_INCLUDE_DIR}/IOKit/ps

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/ps/IOPSKeys.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/ps/IOPSKeys.h ${BUILD_INCLUDE_DIR}/IOKit/ps/IOPSKeys.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/ps/IOPowerSources.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/ps/IOPowerSources.h ${BUILD_INCLUDE_DIR}/IOKit/ps/IOPowerSources.h
fi


# libkern
mkdir -p ${BUILD_INCLUDE_DIR}/libkern

if [ ! -f ${BUILD_INCLUDE_DIR}/libkern/OSTypes.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/libkern/OSTypes.h ${BUILD_INCLUDE_DIR}/libkern/OSTypes.h
fi

if [ ! -f ${BUILD_INCLUDE_DIR}/IOKit/IOKitKeys.h ]; then
  cp /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Versions/A/Headers/IOKitKeys.h ${BUILD_INCLUDE_DIR}/IOKit/IOKitKeys.h
fi
