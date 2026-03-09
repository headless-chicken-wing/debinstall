# User specific environment and startup programs
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

umask 0022


if [ -n "$BASH_VERSION" ]; then
     # include .bashrc if it exists
    if [ -f "$HOME/.config/bashrc.d/.bashrc" ]; then
	. "$HOME/.config/bashrc.d/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi


# set PATH so it includes global private bin if it exists
if [ -d "/usr/local/bin" ] ; then
    PATH="$PATH:/usr/local/bin"
fi

