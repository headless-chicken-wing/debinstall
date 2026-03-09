#!/usr/bin/env bash
# bashrc confiuration source from interactive sessions after ~/.profile

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

#Set user's prompt
PS1="\[\e[38;5;201m\]\u\[\e[38;5;13m\]@\[\e[38;5;51m\]\h\[\e[38;5;10m\] \w\[\e[38;5;13m\] $:\[\e[0m\] "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    #PS1=echo -ne \033]0;${USER}@${HOSTNAME}: ${PWD}\007
    ;;
*)
    ;;
esac


# Require prompt write to history after every command and append to the history file; don't overwrite it
PROMPT_COMMAND='history -a'



# Shell options
shopt -s checkwinsize
shopt -s histappend
shopt -s histreedit
shopt -s cmdhist
shopt -s histverify
shopt -s globstar
set -o noclobber

# History settings
#HISTCONTROL=ignoreboth
HISTFILE="$HOME/.config/bashrc.d/.bash_history."$USER"@"$HOSTNAME""
HISTTIMEFORMAT=" %m-%d-%Y %T "
HISTSIZE=
HISTFILESIZE=

#User specific environment
EDITOR="/usr/bin/nano"
BAT_THEME="Monokai Extended Bright"
PAGER='less'
GREP_COLORS='mt=1;36'
TZ='America/Chicago'

#This avoids matching a part of another directory with "sbin" in it (e.g., /usr/bin/sbin).
if ! [[ "$PATH" =~ (^|:)/sbin(:|$) ]]; then
  PATH="$PATH:/sbin:/usr/sbin"
fi

#Source user's main functions file
if
 [[ -f ~/.config/bashrc.d/.bash_functions ]]; then
 source ~/.config/bashrc.d/.bash_functions; else
 echo -e "No functions found in $USER\'s $HOME"
fi

#Source user's .bash_aliases file
if
 [[ -e ~/.config/bashrc.d/.bash_aliases ]]; then
  source ~/.config/bashrc.d/.bash_aliases; else
  echo "No aliases found in $USER's $HOME"
fi

#Append this login's details to all_logins.log
if
 [[ -f /var/log/all_logins.txt && -n "$SSH_CLIENT" ]]; then
  echo ""$USER" logged into "$HOSTNAME" on $(date) from "$SSH_CLIENT"" | tee -a /var/log/all_logins.txt || echo "ERROR writing login"; elif
 [[ -x /usr/bin/true ]]; then
 /usr/bin/true; else
 true
fi

# enable color support of ls and also add handy aliases
if
 [[ -x /usr/bin/vivid ]]; then
  LS_COLORS="$(vivid generate molokai)"; elif
   [[ -f "$HOME/.local/bin/colors/molokai" ]]; then
    . "$HOME/.local/bin/colors/molokai"; elif
    [[ -x /usr/bin/dircolors ]]; then
   LS_COLORS="$(/usr/bin/dircolors)"; else
   echo "ls_colors left unset" 
  #LS_COLORS='ExGxbEaECxxEhEhBaDaCaD'
fi



# Export some environment variables
export PATH EDITOR BAT_THEME LS_COLORS PAGER TZ
