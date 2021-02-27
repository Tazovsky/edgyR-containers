#! /bin/bash

set -e

echo "Installing build dependencies"
sudo apt-get install -qqy --no-install-recommends \
  libcurl4-openssl-dev \
  libsodium-dev \
  phantomjs
$EDGYR_SCRIPTS/r-packages.R
