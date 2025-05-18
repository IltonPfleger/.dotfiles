#!/bin/bash

if ! grep -Fq "____PJ-SETUP____"  "${HOME}/.bashrc"; then
	echo '#____PJ-SETUP____' >> $HOME/.bashrc
	echo 'source ${HOME}/.dotfiles/bashrc' >> $HOME/.bashrc
	sudo pacman -S xorg-server xorg-xinit libxft ttf-fira-mono rofi ttf-font-awesome ttf-cascadia-code
	sudo pacman -S pipewire pipewire-alsa pipewire-pulse wireplumber rtkit pavucontrol
	sudo usermod -aG audio $USER
	sudo usermod -aG video $USER
	#ssh-keygen -t rsa -b 4096 -C "pfleger@lisha.ufsc.br"
	#ssh-copy-id pfleger@ssh.lisha.ufsc.br
	#ssh-copy-id  -o ProxyJump=pfleger@ssh.lisha.ufsc.br pj@150.162.62.155
fi
