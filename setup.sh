#!/bin/bash
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
dconf load /org/gnome/ < $HOME/.dotfiles/gnome/gnome.txt
