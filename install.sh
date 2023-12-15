#!/bin/bash
set -e

YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NO_COLOR='\033[0m'

sudo apt update

echo -e "${YELLOW}${BOLD}Installing editors, build tools, and languages... ${NO_COLOR}"
### Editing/Building
echo -e "${YELLOW}Installing nvim... ${NO_COLOR}"
sudo snap install nvim --classic
echo "alias nvim='nvim .'" >> ~/.bashrc
echo -e "${YELLOW}Installing Wezterm... ${NO_COLOR}"
./install-wezterm.sh
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
echo -e "${YELLOW}Installing go... ${NO_COLOR}"
./install-go.sh

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


