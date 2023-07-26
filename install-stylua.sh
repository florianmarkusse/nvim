#!/bin/bash

set -e

YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NO_COLOR='\033[0m'

repo_owner="JohnnyMorganz"
repo_name="StyLua"
binary_name="stylua"

# Get the latest release tag from GitHub API
latest_version=$(curl -s "https://api.github.com/repos/${repo_owner}/${repo_name}/releases/latest" | grep -oP '"tag_name": "v\K[^"]+')

# Download the x86-64.zip file of the latest release
wget "https://github.com/${repo_owner}/${repo_name}/releases/download/v${latest_version}/${binary_name}-linux-x86_64.zip"

# Unzip the binary from the downloaded zip file
unzip "${binary_name}-linux-x86_64.zip" -d "${binary_name}"

# Move the binary to /usr/local/bin (you may need sudo permissions)
sudo mv "${binary_name}/${binary_name}" /usr/local/bin/

# Clean up - remove the downloaded zip file and the temporary directory
rm -r "${binary_name}"
rm "${binary_name}-linux-x86_64.zip"

echo -e "${YELLOW}${BOLD}The latest release of ${repo_owner}/${repo_name} has been installed.${NO_COLOR}"

