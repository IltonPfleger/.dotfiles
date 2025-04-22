#!/bin/bash

if ! grep -Fq "____PJ-SETUP____"  "${HOME}/.bashrc"; then
	echo '#____PJ-SETUP____' >> $HOME/.bashrc
	echo 'source ${HOME}/.dotfiles/bashrc' >> $HOME/.bashrc
	dconf load /org/gnome/ < $HOME/.dotfiles/gnome/gnome.txt
	gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.dotfiles/backgrounds/may-the-force-be-with-you.jpg"
fi
