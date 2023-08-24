#!/bin/bash

PROJECT_ROOT="$(pwd)"

# LOCATIONS to backup, path must be relative to your $HOME
declare -a LOCATIONS=(".config/waybar" ".config/sway" ".config/foot" ".config/rofi" ".config/mako" ".config/nvim")

for ITEM in "${LOCATIONS[@]}"; do
    printf "Backing up %s\n" "$ITEM"
    mkdir -p "./$ITEM"
    rsync --recursive "$HOME/$ITEM/" "./$ITEM"
done
