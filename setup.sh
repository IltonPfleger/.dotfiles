#!/bin/bash
mv $HOME/.bashrc $HOME/bashrc.back
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/.dotfiles/clang-format $HOME/.clang-format
$HOME/.dotfiles/gnome/load.sh
