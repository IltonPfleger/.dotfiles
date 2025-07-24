#!/bin/bash
sudo pacman -S gnome-session gnome-shell gdm gnome-control-center nautilus ttf-fira-code firefox wl-clipboard
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
dconf load /org/gnome/ < $HOME/.dotfiles/gnome/gnome.txt
