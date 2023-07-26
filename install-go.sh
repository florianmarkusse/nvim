#!/bin/bash

set -e

YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NO_COLOR='\033[0m'


latest_version=$(curl -s https://go.dev/VERSION?m=text)
wget "https://golang.org/dl/${latest_version}.linux-amd64.tar.gz"

sudo tar -C /usr/local -xzf ${latest_version}.linux-amd64.tar.gz

echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc

rm ${latest_version}.linux-amd64.tar.gz
