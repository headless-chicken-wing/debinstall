#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Debian Trixie — New User Setup
# Usage: curl -fsSL https://raw.githubusercontent.com/headless-chicken-wing/debinstall/refs/heads/main/install.sh | bash
# =============================================================================

# -----------------------------------------------------------------------------
# Color / formatting variables
# -----------------------------------------------------------------------------
YW=$(echo "\033[33m")
GN=$(echo "\033[1;92m")
RD=$(echo "\033[01;31m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
CM='\xE2\x9C\x94\xef\xb8\x8f'
CROSS='\xE2\x9D\x8C'

# -----------------------------------------------------------------------------
# Messaging helpers
# -----------------------------------------------------------------------------
msg_info() {
  echo -e "${YW}  ${1}${CL}"
}

msg_ok() {
  echo -e "${BFR} ${CM} ${GN}${1}${CL}"
}

msg_error() {
  echo -e "${BFR} ${CROSS} ${RD}${1}${CL}"
}

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
dependencies=(
  'bat'
  'bmon'
  'bridge-utils'
  'btop'
  'bzip2'
  'coreutils'
  'cowsay'
  'curl'
  'diffutils'
  'duf'
  'e2fsprogs'
  'efibootmgr'
  'eject'
  'ethtool'
  'evince'
  'eza'
  'fastfetch'
  'fd-find'
  'fdisk'
  'feh'
  'ffmpeg'
  'figlet'
  'file'
  'fontconfig'
  'fonts-cantarell'
  'fonts-dejavu'
  'fonts-dejavu-core'
  'fonts-dejavu-web'
  'fonts-font-awesome'
  'fonts-font-logos'
  'fonts-glyphicons-halflings'
  'fonts-liberation'
  'fzf'
  'gdisk'
  'git'
  'glances'
  'gparted'
  'grep'
  'gzip'
  'hostname'
  'htop'
  'iftop'
  'info'
  'inxi'
  'iotop'
  'iproute2'
  'jq'
  'lolcat'
  'lsd'
  'lshw'
  'lsmount'
  'lsof'
  'nano'
  'ncdu'
  'neofetch'
  'nmap'
  'parted'
  'ripgrep'
  'tcpdump'
  'tealdeer'
  'tldr'
  'toilet'
  'traceroute'
  'vivid'
  'wget'
  'whois'
)

# -----------------------------------------------------------------------------
# Checks
# -----------------------------------------------------------------------------
root_check() {
  if [[ "$(id -u)" -ne 0 ]]; then
    msg_error "Please run this script as root. Exiting."
    exit 1
  fi
}

os_check() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
  else
    msg_error "Cannot find /etc/os-release. Exiting."
    exit 1
  fi

  if [[ "${VERSION_CODENAME}" != "trixie" ]]; then
    msg_error "This script is intended for Debian Trixie. Detected: ${PRETTY_NAME}. Exiting."; elif
	[[ "${ID_LIKE}" != "*debian*" ]]; then
    msg_error "This script is intended for Debian systems. Detected: ${PRETTY_NAME}. Exiting."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
# System
# -----------------------------------------------------------------------------
get_updates() {
  msg_info "Updating apt repositories..."
  apt-get update &>/dev/null
  msg_ok "Repositories updated."
}

get_upgrades() {
  msg_info "Installing upgrades — this may take a while..."
  apt-get upgrade -yy &>/dev/null
  msg_ok "System upgraded."
}

# -----------------------------------------------------------------------------
# Packages
# -----------------------------------------------------------------------------
install_dependencies() {
  msg_info "Installing packages..."
  for pkg in "${dependencies[@]}"; do
    if apt-get install -y "${pkg}" &>/dev/null; then
      msg_ok "Installed: ${pkg}"
    else
      msg_error "Failed to install: ${pkg}"
    fi
  done
}

verify_dependencies() {
  msg_info "Verifying installed packages..."
  local missing=0
  for pkg in "${dependencies[@]}"; do
    if ! dpkg -s "${pkg}" &>/dev/null; then
      msg_error "Missing: ${pkg}"
      ((missing++))
    fi
  done
  if [[ "${missing}" -eq 0 ]]; then
    msg_ok "All packages verified."
  else
    msg_error "${missing} package(s) failed to install."
  fi
}

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
create_dirs() {
  msg_info "Creating user directories..."
  local dirs=(
    "${HOME}/.config/bashrc.d"
    "${HOME}/.local/bin"
    "${HOME}/.local/functions"
  )
  for dir in "${dirs[@]}"; do
    if [[ ! -d "${dir}" ]]; then
      mkdir -p "${dir}" && msg_ok "Created: ${dir}"
    else
      msg_info "Already exists: ${dir}"
    fi
  done
}

# -----------------------------------------------------------------------------
# Download files from repo
# -----------------------------------------------------------------------------
REPO_URL="https://github.com/headless-chicken-wing/debinstall/archive/refs/heads/main.tar.gz"
TMP_DIR="$(mktemp -d)"

download_files() {
  msg_info "Downloading repo archive..."
  curl -fsSL "${REPO_URL}" -o "${TMP_DIR}/debinstall.tar.gz"
  tar -xzf "${TMP_DIR}/debinstall.tar.gz" -C "${TMP_DIR}"
  msg_ok "Repo downloaded and extracted."

  msg_info "Copying bashrc.d files..."
  cp -r "${TMP_DIR}/debinstall-main/bashrc.d/." "${HOME}/.config/bashrc.d/"
  msg_ok "bashrc.d files in place."

  msg_info "Copying bin scripts..."
  cp -r "${TMP_DIR}/debinstall-main/bin/." "${HOME}/.local/bin/"
  msg_ok "bin scripts in place."

  msg_info "Copying functions..."
  cp -r "${TMP_DIR}/debinstall-main/functions/." "${HOME}/.local/functions/"
  msg_ok "functions in place."

  msg_info "Cleaning up temp files..."
  rm -rf "${TMP_DIR}"
  msg_ok "Cleanup done."
}

# -----------------------------------------------------------------------------
# Permissions
# -----------------------------------------------------------------------------
set_permissions() {
  msg_info "Setting executable permissions on ~/.local/bin..."
  chmod +x "${HOME}"/.local/bin/*
  msg_ok "Permissions set."
}

# -----------------------------------------------------------------------------
# Symlinks
# -----------------------------------------------------------------------------
create_symlinks() {
  msg_info "Creating symlinks..."

  # batcat -> bat
  if [[ -x /usr/bin/batcat ]] && [[ ! -e /usr/bin/bat ]]; then
    ln -s /usr/bin/batcat /usr/bin/bat && msg_ok "Symlinked: batcat -> bat"
  elif [[ -e /usr/bin/bat ]]; then
    msg_info "Symlink already exists: /usr/bin/bat"
  else
    msg_error "batcat not found, skipping symlink."
  fi
}

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
summary() {
  echo
  msg_ok "======================================"
  msg_ok " Setup complete!"
  msg_ok "======================================"
  echo
  msg_info "Directories configured:"
  msg_info "  ~/.config/bashrc.d"
  msg_info "  ~/.local/bin"
  msg_info "  ~/.local/functions"
  echo
  msg_info "Next steps:"
  msg_info "  - Source your bashrc: source ~/.bashrc"
  msg_info "  - Verify your PATH includes ~/.local/bin"
  echo
}

# =============================================================================
# Main
# =============================================================================
IFS=$'\n\t'

root_check
os_check

echo
msg_info "Welcome to the setup utility for ${PRETTY_NAME}"
echo

read -rp "  This script will configure a new user environment. Start now? [y/N]: " start_answer
start_answer="${start_answer,,}"
echo

case "${start_answer}" in
  y|yes) msg_ok "Starting setup..." ;;
  n|no|"") msg_info "Exit requested. Exiting."; exit 0 ;;
  *) msg_error "Invalid response: '${start_answer}'. Exiting."; exit 1 ;;
esac

echo
get_updates
get_upgrades
install_dependencies
verify_dependencies
create_dirs
download_files
set_permissions
create_symlinks
summary

exit 0
