#!/bin/sh

. ./config.sh

./build_monero.sh
./setup.sh

rm -rf ../../../monero_flutter/macos/external/include
rm -rf ../../../monero_flutter/macos/external/lib
rm -rf ../../../monero_flutter/example/build

cp -r dist/ ../../../monero_flutter/macos/external/