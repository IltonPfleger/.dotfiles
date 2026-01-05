#!/bin/bash
mv $HOME/.bashrc $HOME/bashrc.back
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
$HOME/.dotfiles/gnome/load.sh
