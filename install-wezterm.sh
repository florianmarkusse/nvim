#!/bin/bash

set -e

REPO_OWNER="wez"
REPO_NAME="wezterm"
DOWNLOAD_DIR="$HOME/wezterm_downloads"

RELEASE_JSON=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")
RELEASE_TAG=$(echo "$RELEASE_JSON" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

DEB_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/$RELEASE_TAG/$REPO_NAME-$RELEASE_TAG.Ubuntu22.04.deb"

mkdir -p "$DOWNLOAD_DIR"

DEB_FILENAME="$DOWNLOAD_DIR/$REPO_NAME-$RELEASE_TAG-linux.deb"
curl -L -o "$DEB_FILENAME" "$DEB_URL"

sudo dpkg -i "$DEB_FILENAME"

sudo apt-get -y install -f 

rm "$DEB_FILENAME"

echo "$REPO_NAME $RELEASE_TAG has been downloaded and installed."

rmdir "$DOWNLOAD_DIR"
