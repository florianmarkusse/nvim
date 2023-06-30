#!/bin/bash

set -e

YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NO_COLOR='\033[0m'

sudo apt install -y libautodie-perl

latest_version=$(curl -s https://api.github.com/repos/darold/pgFormatter/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
wget "https://github.com/darold/pgFormatter/archive/refs/tags/v${latest_version}.tar.gz"
tar xzf "v${latest_version}.tar.gz"
cd "pgFormatter-${latest_version}/"
perl Makefile.PL
make && sudo make install
cd ../ && rm -rf "v${latest_version}.tar.gz" && rm -rf "pgFormatter-${latest_version}" # clean up
