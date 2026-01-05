#!/bin/bash
mv $HOME/.bashrc $HOME/bashrc.back
ln -s $HOME/.dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/.dotfiles/clang-format $HOME/.clang-format
$HOME/.dotfiles/gnome/load.sh


#Galaxy Book 3 
echo 80 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold
echo true | sudo tee /sys/class/firmware-attributes/samsung-galaxybook/attributes/power_on_lid_open/current_value

