#!/bin/bash

if ! grep -Fq "____PJ-SETUP____"  "${HOME}/.bashrc"; then
	echo '#____PJ-SETUP____' >> $HOME/.bashrc
	echo 'source ${HOME}/.dotfiles/bashrc' >> $HOME/.bashrc
	#ssh-keygen -t rsa -b 4096 -C "pfleger@lisha.ufsc.br"
	#ssh-copy-id pfleger@ssh.lisha.ufsc.br
	#ssh-copy-id  -o ProxyJump=pfleger@ssh.lisha.ufsc.br pj@150.162.62.155
	dconf load /org/gnome/ < $HOME/.dotfiles/gnome/gnome.txt
fi
