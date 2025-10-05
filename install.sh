#!/bin/bash
set -e

YELLOW='\033[33m'
BOLD='\033[1m'
NO_COLOR='\033[0m'

sudo apt update

echo -e "${YELLOW}${BOLD}Installing editors, build tools, and languages... ${NO_COLOR}"
### Editing/Building
echo -e "${YELLOW}Installing tmux... ${NO_COLOR}"
sudo apt install tmux
echo -e "${YELLOW}Installing clang... ${NO_COLOR}"
sudo apt install -y clang
echo -e "${YELLOW}Installing cmake... ${NO_COLOR}"
sudo apt install -y cmake
echo -e "${YELLOW}Installing cppcheck... ${NO_COLOR}"
sudo apt install -y cppcheck
echo -e "${YELLOW}Installing xclip... ${NO_COLOR}"
sudo apt install -y xclip
echo -e "${YELLOW}Installing BEAR... ${NO_COLOR}"
sudo apt-get install -y bear
echo -e "${YELLOW}Installing node... ${NO_COLOR}"
sudo apt install -y nodejs
echo -e "${YELLOW}Installing python... ${NO_COLOR}"
sudo apt install -y python3
sudo apt install -y python-is-python3
sudo apt install python3-pip
sudo apt install python3-venv
echo -e "${YELLOW}Installing go... ${NO_COLOR}"
sudo apt install -y golang-go
echo -e "${YELLOW}Installing cargo... ${NO_COLOR}"
sudo apt  install -y cargo
echo -e "${YELLOW}Installing luarocks... ${NO_COLOR}"
sudo apt  install -y luarocks
echo -e "${YELLOW}Installing ruby... ${NO_COLOR}"
sudo apt  install -y ruby
echo -e "${YELLOW}Installing ruby-gems... ${NO_COLOR}"
sudo apt  install -y ruby-rubygems
echo -e "${YELLOW}Installing composer... ${NO_COLOR}"
sudo apt  install -y composer
echo -e "${YELLOW}Installing php8.3-cli... ${NO_COLOR}"
sudo apt  install -y php8.3-cli
echo -e "${YELLOW}Installing npm... ${NO_COLOR}"
sudo apt  install -y npm
echo -e "${YELLOW}Installing openjdk-21-jdk-headless... ${NO_COLOR}"
sudo apt  install -y openjdk-21-jdk-headless
echo -e "${YELLOW}Installing openjdk-21-jre-headless... ${NO_COLOR}"
sudo apt  install -y openjdk-21-jre-headless
echo -e "${YELLOW}Installing ripgrep... ${NO_COLOR}"
sudo apt-get -y install ripgrep
echo -e "${YELLOW}Installing sqlite... ${NO_COLOR}"
sudo apt-get -y install sqlite3 libsqlite3-dev
echo -e "${YELLOW}Installing gdb frontend stuff... ${NO_COLOR}"
wget -P ~ https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit
sudo apt install -y python3-pygments

echo -e "${YELLOW}${BOLD}Installing LSPs... ${NO_COLOR}"
### LSPs
# C/C++
echo -e "${YELLOW}Installing clangd... ${NO_COLOR}"
sudo apt-get install -y clangd-12
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
# CMake
echo -e "${YELLOW}Installing CMake... ${NO_COLOR}"
sudo apt install -y python3-pip
sudo pip install cmake-language-server
# CSS & HTML
echo -e "${YELLOW}Installing vscode-langservers... ${NO_COLOR}"
npm i -g vscode-langservers-extracted
# TypeScript & JavaScript
echo -e "${YELLOW}Installing svelte-language-server... ${NO_COLOR}"
npm i -g svelte-language-server
# BASH
echo -e "${YELLOW}Installing bash-language-server... ${NO_COLOR}"
npm i -g bash-language-server

echo -e "${YELLOW}${BOLD}Installing formatters... ${NO_COLOR}"
### Formatters
# C/C++
echo -e "${YELLOW}Installing clang-format... ${NO_COLOR}"
sudo apt install -y clang-format
echo -e "${YELLOW}Installing clang-tidy... ${NO_COLOR}"
sudo apt install -y clang-tidy
# CSS, HTML, TypeScript, and JavaScript
echo -e "${YELLOW}Installing prettier... ${NO_COLOR}"
npm install -g prettier
# Lua
echo -e "${YELLOW}Installing stylua... ${NO_COLOR}"
./install-sql-formatter.sh
# SQL
echo -e "${YELLOW}Installing pg_format... ${NO_COLOR}"
./install-sql-formatter.sh
echo -e "${YELLOW}Installing shfmt... ${NO_COLOR}"
go install mvdan.cc/sh/v3/cmd/shfmt@latest
echo -e "${YELLOW}Installing shellcheck... ${NO_COLOR}"
sudo apt install shellcheck

echo -e "${YELLOW}Setting up bash configuration... ${NO_COLOR}"
./bash-configuration.sh

cp .gdbinit "$HOME/.gdbinit"

source "$HOME/.bashrc"

echo -e "${YELLOW}${BOLD}SUCCESS!!! ${NO_COLOR}"
