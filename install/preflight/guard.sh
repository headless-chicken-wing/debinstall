#!/usr/bin/env bash
# This function sets various color variables using ANSI escape codes for formatting text in the terminal.
YW="\033[33m"
BL="\033[36m"
RD="\033[01;31m"
BGN="\033[4;92m"
GN="\033[1;92m"
DGN="\033[32m"
CL="\033[m"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"
BFR="\\r\\033[K"

# This function displays an informational message with a yellow color.
msg_info() {
  local msg="$1"
  echo -e "${YW}${msg}${CL}"
}

# This function displays a success message with a green color.
msg_ok() {
  local msg="$1"
  echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

# This function displays a error message with a red color.
msg_error() {
  local msg="$1"
  echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

abort() {
  msg_error "Debian install requires: $1"
  echo
  gum confirm "Proceed anyway on your own accord and without assistance?" || exit 1
}

# Must be Debian or Debian derititive

if [[ -f /etc/os-release ]]; then
   source /etc/os-release
  if [[ $ID != debian ]]; then
   abort "Debian Stable"
 fi
fi

# Must be x86 only to fully work
if [[ $(uname -m) != "x86_64" ]]; then
  abort "x86_64 CPU"
fi


msg_ok "Cleared all system compatibility checks!"


