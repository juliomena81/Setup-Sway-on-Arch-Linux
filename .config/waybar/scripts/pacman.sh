#!/usr/bin/env bash
alacritty -e bash -c "sudo pacman -Syu && pkill -RTMIN+8 waybar"
