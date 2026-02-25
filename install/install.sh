#!/usr/bin/bash
set -e

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

dependencies=(
#	'adduser'
#	'bashacks'
#	'bashbro'
#	'bash-completion'
#	'bash-doc'
#	'bashtop'
	'bat'
	'bmon'
	'bridge-utils'
	'btop'
#	'btrfs-progs'
	'bzip2'
#	'cifs-utils'
	'coreutils'
	'cowsay'
	'curl'
#	'debian-faq'
#	'debianutils'
	'diffutils'
#	'dmidecode'
#	'dmsetup'
#	'doc-debian'
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
#	'firmware-intel-graphics'
#	'firmware-iwlwifi'
#	'firmware-linux-nonfree'
#	'firmware-misc-nonfree'
#	'firmware-realtek'
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
#	'glusterfs-client'
#	'glusterfs-common'
	'gparted'
#	'gping'
	'grep'
	'gzip'
	'hostname'
	'htop'
	'iftop'
	'info'
#	'intel-gpu-tools'
#	'intel-microcode'
	'inxi'
	'iotop'
	'iproute2'
	'jq'
#	'linux-base'
	'lolcat'
	'lsd'
	'lshw'
	'lsmount'
	'lsof'
#	'manpages'
	'nano'
	'ncdu'
	'neofetch'
#	'netcat-traditional'
#	'nfs-common'
	'nmap'
	'parted'
	'ripgrep'
#	'sshfs'
#	'tasksel'
#	'task-ssh-server'
#	'task-web-server'
	'tcpdump'
	'tealdeer'
	'tldr'
	'toilet'
	'traceroute'
	'vivid'
#	'waycheck'
#	'wayland-utils'
#	'wayout'
#	'waypipe'
	'wget'
#	'whiptail'
	'whois'
	'fuckwhois'
)

msg_info() {
  local msg="$1"
  echo -e "${YW}${msg}${CL}"
}

msg_ok() {
  local msg="$1"
  echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

msg_error() {
  local msg="$1"
  echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

didrun()
 {
   local code="$?"
   if [[ ${code} -ne "0" ]]; then
   msg_error "Exit error ${code}"; elif
   [[ ${code} -eq "0" ]]; then
   msg_ok "Exit Ok"
   fi
 }

get_updates()
  {
     msg_info "Getting repository updates..." && sleep 4
     apt-get update &> /dev/null && msg_ok "Apt repositories have been updated..."
  }

get_upgrades()
  {
     msg_info "Getting repository upgrades now......" && sleep 4
     msg_info "Please be patient while upgrades are being installed on your system...."
     apt-get upgrade -yy &> /dev/null && msg_ok "All upgrades have been installed..."
  }

check_dependencies()
  {
   sleep 3
   msg_info "Checking installed packages for missing dependencies..."
   sleep 2
   msg_info "Please Wait..."
   sleep 2
   msg_info "...................."
    for dep in "${dependencies[@]}"; do
       ! command -v "${dep}" &> /dev/null && msg_error "Missing ${dep}"
   done
  }

install_dependencies()
  {
   msg_info "Installing missing packages now..."
    sleep 2
     msg_info "This may take a while..."
      sleep 2
       msg_info "Patience...." 
      for inst in "${dependencies[@]}"; do
     apt info "${inst}" &> /dev/null &&  apt install "${inst}" --dry-run &> /dev/null && msg_ok "Installed ${inst}" || msg_error "Failed installing ${inst}..."
   done
  }

root_check() {
  if [[ "$(id -u)" -ne 0 || $(ps -o comm= -p $PPID) == "sudo" ]]; then
    msg_error "Please run this script as root."
    msg_info  "Exiting..."
    sleep 2
    exit
  fi
}

IFS=$'\n\t'

# Load distribution information
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
else
  msg_error "Cannot find /etc/os-release. Exiting."
  exit 1
fi

msg_info "Welcome to the configuration setup utility for ${PRETTY_NAME}"

# Prompt to start
read -rp "This setup script will configure a new user's personal settings inside their home directory. Start now? [y/N]: " start_answer
start_answer=${start_answer,,}  # convert to lowercase

echo
case "${start_answer}" in
  y|yes)
    msg_ok "Continuing with configuration utility..." ;;
  n|no|"" )
    msg_info "Exit requested; exiting now."
    exit 0 ;;
  *)
    msg_error "Invalid response: '${start_answer}'. Exiting."
    exit 1 ;;
esac

sleep 3
#root_check
get_updates
sleep 2
get_upgrades
sleep 2
check_dependencies
sleep 2
install_dependencies
sleep 4
msg_ok "All available system dependencies available have been installed..."
sleep 3
msg_ok "Please wait...."
sleep 3
msg_info "Setting up symlinks for deprecated conveineance..."
sleep 3
if
 [[ ! -x /usr/bin/batcat ]]; then
  msg_error "batcat is not available..."; elif
 [[ -x /usr/bin/batcat ]]; then
   if [[ ! -x /usr/bin/bat ]]; then
    ln -s /usr/bin/batcat /usr/bin/bat && msg_ok "batcat is symlinked to /usr/bin/bat"; else
    msg_error "File exists.." && sleep 4;
  fi
fi
sleep 4

set +e

exit 0
