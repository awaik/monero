#!/bin/sh

HOST_NCORES=$(nproc 2>/dev/null || shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)

cd ../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile
make release-static -j$HOST_NCORES