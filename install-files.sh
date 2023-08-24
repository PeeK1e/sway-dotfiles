#!/bin/bash

PROJECT_ROOT="$(pwd)"

# LOCATIONS to backup, path must be relative to your $HOME
declare -a LOCATIONS=(".config/waybar" ".config/sway" ".config/foot" ".config/rofi" ".config/mako" ".config/nvim")

for ITEM in "${LOCATIONS[@]}"; do
    printf "Copying %s\n" "$ITEM"
    mkdir -p "$HOME/$ITEM"
    rsync --recursive "./$ITEM/" "$HOME/$ITEM"
done

post_copy_script() {
    _pwd=`pwd`
    cd .config/rofi/basic
    bash install.sh

    cd $_pwd
}

post_copy_script
