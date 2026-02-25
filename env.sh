#!/usr/bin/env bash

#Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Debian locations
export DEBIAN_PATH="$HOME/repos/debinstall"
export DEBIAN_INSTALL="$DEBIAN_PATH/install"
export DEBIAN_INSTALL_LOG_FILE="$DEBIAN_PATH/log/debian-install.log"
export PATH="$DEBIAN_PATH/bin:$PATH"

# Install
source "$DEBIAN_INSTALL/helpers/all.sh"
source "$DEBIAN_INSTALL/preflight/all.sh"
source "$DEBIAN_INSTALL/packaging/all.sh"
source "$DEBIAN_INSTALL/config/all.sh"
source "$DEBIAN_INSTALL/login/all.sh"
source "$DEBIAN_INSTALL/post-install/all.sh"
