#!/bin/bash

if ! grep -Fq "____PJ-SETUP____"  "${HOME}/.bashrc"; then
	echo '#____PJ-SETUP____' >> $HOME/.bashrc
	echo 'source ${HOME}/.dotfiles/bashrc' >> $HOME/.bashrc
	sudo pacman -S git make cmake alacritty sway swaybg rofi-wayland waybar

	ln -s sway/waybar/ ~/.config/waybar
	ln -s sway/rofi ~/.config/rofi
	ln -s sway/ ~/.config/sway

	#ssh-keygen -t rsa -b 4096 -C "pfleger@lisha.ufsc.br"
	#ssh-copy-id pfleger@ssh.lisha.ufsc.br
	#ssh-copy-id  -o ProxyJump=pfleger@ssh.lisha.ufsc.br pj@150.162.62.155
fi
