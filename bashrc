#!/bin/bash
[[ $- != *i* ]] && return

#-----------------------------
# Git Integration
#-----------------------------
get_branch() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    [[ -n "$branch" ]] && echo " ${branch}"
}

#-----------------------------
# Style
#-----------------------------
ART=$'\e[34m                  
                 ▄█▄
                ▄███▄
               ▄█████▄
              ▄███████▄
             ▄ ▀▀██████▄
            ▄██▄▄ ▀█████▄
           ▄█████████████▄
          ▄███████████████▄
         ▄█████████████████▄
        ▄███████████████████▄
       ▄█████████▀▀▀▀████████▄
      ▄████████▀      ▀███████▄
     ▄█████████        ████▀▀██▄
    ▄██████████        █████▄▄▄
   ▄██████████▀        ▀█████████▄
  ▄██████▀▀▀              ▀▀██████▄
 ▄███▀▀                       ▀▀███▄
▄▀▀                               ▀▀▄\e[0m
'
BLUE='\[\e[34m\]'
RED='\[\e[91;1m\]'
RESET='\[\e[0m\]'
while IFS= read -r line; do
	echo -e "\033[34m${line}\033[0m"
	sleep 0.005
done <<< "$ART"
PS1="${BLUE} \w :: \u@\H${RESET} :: ${RED}\$(get_branch)${RESET} > "


#-----------------------------
# Environment Variables
#-----------------------------
export GTK_THEME=Adwaita:dark
export HISTCONTROL=ignoreboth
export HISTSIZE=50
export LANG="en_US.UTF-8"
export EDITOR=vim

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
alias c='wl-copy'
alias p='wl-paste'
