if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
#  deprecated as of https://wiki.archlinux.org/title/GNOME/Keyring#gcr-ssh-agent
#  eval $(gnome-keyring-daemon --start)
#  export SSH_AUTH_SOCK
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
  export QT_STYLE_OVERRIDE='gtk2'
  export QT_QPA_PLATFORM='wayland'
#  export GTK_THEME='Catppuccin-Mocha-Standard-Mauve-dark'
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CURRENT_DESKTOP="sway" 
  export MOZ_ENABLE_WAYLAND=1
  # GTK3 applications take a long time to start
#  systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
#  hash dbus-update-activation-environment 2>/dev/null && \
#    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

  gnome-keyring-daemon --start --components="secrets,ssh,pkcs11"
  exec /usr/bin/sway
fi

