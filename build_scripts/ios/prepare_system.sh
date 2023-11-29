#!/bin/sh

. ./config.sh

cd $SCRIPTS_DIR/../../external/monero-cpp/external/monero-project
brew update && brew bundle --file=contrib/brew/Brewfile
brew remove hidapi