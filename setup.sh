#!/bin/bash

if ! grep -Fq "____PJ-SETUP____"  "${HOME}/.bashrc"; then
	echo '#____PJ-SETUP____' >> $HOME/.bashrc
	echo 'source ${HOME}/.dotfiles/bashrc' >> $HOME/.bashrc
	sudo pacman -S dmenu xorg-server xorg-xinit libxft ttf-fira-mono ttf-font-awesome xorg-xrandr feh network-manager-applet
	sudo pacman -S pipewire pipewire-alsa pipewire-pulse wireplumber rtkit pavucontrol
	sudo usermod -aG audio $USER
	sudo usermod -aG video $USER
	ln -s $HOME/.dotfiles/startx $HOME/.xinitrc
	#ssh-keygen -t rsa -b 4096 -C "pfleger@lisha.ufsc.br"
	#ssh-copy-id pfleger@ssh.lisha.ufsc.br
	#ssh-copy-id  -o ProxyJump=pfleger@ssh.lisha.ufsc.br pj@150.162.62.155
fi
