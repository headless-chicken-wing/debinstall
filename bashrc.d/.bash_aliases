# Custom aliases found through my many hours of
# reading help blogs or otherwise made by me.
# For ease of use aliases.d is sourced by .bashrc
# during interactive or login user sessions, and is
# hard coded to be read from  ~/.config/bashrc.d/aliases.d
# filepath. This scheme will change, however, as part
# of an ongoing plan to consolidate, organize, and
# automate the previous user scheme.

# Common and universally used aliases

# Built-in default flag sets and changes
alias sudo='sudo '

##Built-in "cd" options##
alias ..='cd ../ && la'
alias ...='cd ../../ && la'
alias ....='cd ../../.. && la'
alias ..r='cd /run && la'
alias ..e='cd /etc && la'
alias ..u='cd /usr && la'
alias ..v='cd /var && la'
alias ..l='cd /lib && la'
alias ..b='cd /bin && la'
alias ..s='cd /sbin && la'

#Give globally installed "lsd" package it's own suedo alias
#This is to easily change linked aliases if future environment is missing the "lsd" package

alias ls='ls -A --color=auto'
alias lsa='lsd -FA --icon-theme unicode '
#alias lsa='ls -F'

#Attach desired "ls" configurations
alias la='lsa'
alias ld='lsa -ltr'
alias ll='lsa -l'
alias lt='lsa --timesort -lr'
alias lz='lsa -lrS --total-size'
alias lr='lsa -lrR --timesort'

#Built-in commands to include options as default
#Should any of these not be desired while running,
#you can disable on the command line by adding a
#backslash(\) in front of the command.
#for example: $\cat filename
alias rm='rm -Irf'
alias cp='cp -i -r'
alias mv='mv -i'
alias ping='ping -c 3 -- '
alias mkdir='mkdir -p -v'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias top='htop'
alias cat='/usr/bin/bat'
#alias ip='ip -c=auto '

# User aliases
#alias pic='feh --borderless -P --cache-size 2048 -r -F -g 940x780 --auto-zoom --scale-down $1'
#alias pic='feh --borderless -P --cache-size 2048 -r -F --auto-zoom --scale-down '
alias dmess='sudo dmesg -HL --color=auto | command bat -l "Bourne Again Shell (bash)"'
#alias lsbla='lsblk --output NAME,SIZE,TYPE,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,PATH,MOUNTPOINTS | /usr/bin/bat -p -P -l perl'
alias free='free -htl'
alias curlme='curl -sS https://ident.me/json | jq '.' '
alias ports='sudo ss --all --numeric --processes --ipv4 --ipv6'
alias bashing='nano ~/.config/bashrc.d/.bashrc'
alias restart='sync && systemctl reboot --full'
alias reboot='sync && systemctl reboot --full'
alias largest='du -ah . | sort -rh | head -n 10'
alias sos='sudo systemctl status | head -n 7 | command bat -l perl'
alias resource='source ~/.config/bashrc.d/.bashrc'
alias hist='history'
alias aliasing='nano ~/.config/bashrc.d/.bash_aliases'
alias realias='. ~/.config/bashrc.d/.bash_aliases'
#alias didrun='echo $?'
#alias man='command man '
alias logs='sudo journalctl -r | /usr/bin/bat -l syslog'
alias edit-fstab='sudo nano /etc/fstab'
alias edit-resolv='sudo nano /etc/resolvctl'
alias edit-bashrc='nano $HOME/.bashrc'
alias edit-hosts='sudo nano /etc/hosts'
alias fd='sudo /usr/bin/fd --hidden -u -L -d 10 --color=auto --exclude /sys --exclude /proc --exclude /mnt/lfs '
alias lc='wc --lines'
alias pic='feh --zoom 100 --fullscreen --auto-zoom --draw-exif --scale-down --recursive --on-last-slide hold --borderless -P --cache-size 2048 -d '
#alias com='/home/brandon/.local/bin/roku-press-select.py && echo "Note: $1 "$(date)"" | tee -a /var/log/yt.log'
