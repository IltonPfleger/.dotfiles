#!/bin/bash

# Return if not running interactively
[[ $- != *i* ]] && return

#-----------------------------
# Environment Variables
#-----------------------------
export GTK_THEME=Adwaita:dark
export LIBVA_DRIVERS_PATH=/usr/lib/dri
export LIBVA_DRIVER_NAME=iHD
export HISTCONTROL=ignoreboth
export HISTSIZE=50
export LANG="en_US.UTF-8"

#-----------------------------
# Welcome Message
#-----------------------------

[[ -z "$SSH_CONNECTION" ]] && clear
echo -e "Welcome back, \033[1;32m$USER!\033[0m"
echo -e "System: \033[1;34m$(uname -srm)\033[0m"
echo -e "Today is: \033[1;33m$(date '+%Y-%m-%d %H:%M:%S')\033[0m"
echo -e "Uptime: \033[1;35m$(uptime -p)\033[0m"

#-----------------------------
# Firmware Tools
#-----------------------------
if [[ -f /sys/firmware/acpi/platform_profile ]]; then
    alias mode='cat /sys/firmware/acpi/platform_profile'
    alias low-power='echo low-power | sudo tee /sys/firmware/acpi/platform_profile'
    alias quiet='echo quiet | sudo tee /sys/firmware/acpi/platform_profile'
    alias balanced='echo balanced | sudo tee /sys/firmware/acpi/platform_profile'
    alias performance='echo performance | sudo tee /sys/firmware/acpi/platform_profile'
fi

#-----------------------------
# Aliases
#----------------------------- 
alias q='exit'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lisha='ssh -J pfleger@ssh.lisha.ufsc.br pj@150.162.62.155 -X'
alias lisha_ecu='ssh -J pfleger@ssh.lisha.ufsc.br lisha@150.162.62.227 -X'


#-----------------------------
#Vim
#----------------------------- 
export EDITOR=vim
export VIMINIT='source ${HOME}/.dotfiles/vim/main.vim'
alias clang-format='${HOME}/.dotfiles/bin/clang-format'

#-----------------------------
#Clipboard handling
#----------------------------- 
if command -v xclip &>/dev/null; then
    alias c='xclip -selection clipboard'
    alias p='xclip -o -selection clipboard'
fi


#-----------------------------
# Git Integration
#-----------------------------
get_branch() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    [[ -n "$branch" ]] && echo "git:[${branch}]"
}


PS1='\[\e[38;5;27m\]pj\[\e[0m\] :: \[\e[38;5;27;1m\]\w\[\e[0m\] :: \[\e[91;1m\]$(get_branch)\[\e[0m\] > '

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	export DISPLAY=:0
	pkill -u "$USER" -fx /usr/bin/pipewire-pulse 1>/dev/null 2>&1
	pkill -u "$USER" -fx /usr/bin/wireplumber 1>/dev/null 2>&1
	pkill -u "$USER" -fx /usr/bin/pipewire 1>/dev/null 2>&1
	
	/usr/bin/pipewire > /dev/null 2>&1 &

	while [ "$(pgrep -f /usr/bin/pipewire)" = "" ] ; do
	   sleep 1
	done
	
	/usr/bin/wireplumber > /dev/null 2>&1 &
	/usr/bin/pipewire-pulse > /dev/null 2>&1 &
	XINITRC=$HOME/.dotfiles/startx startx
fi
