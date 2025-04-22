#!/bin/bash
export DISPLAY=:0
alacritty --config-file $(dirname "$0")/main.toml "$@"
