#!/bin/bash
sudo usermod -aG audio $USER
sudo usermod -aG video $USER
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
