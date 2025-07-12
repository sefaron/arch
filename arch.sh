#!/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Packages to uninstall

UNINSTALL_PACKAGE=(
  baobab
  epiphany
  evince
  gnome-calendar
  gnome-clocks
  gnome-connections
  gnome-console
  gnome-contacts
  gnome-logs
  gnome-maps
  gnome-music
  gnome-remote-desktop
  gnome-shell-extensions
  gnome-software
  gnome-system-monitor
  gnome-tour
  gnome-user-docs
  showtime
  simple-scan
  snapshot
  totem
  yelp
)

for package in "${UNINSTALL_PACKAGE[@]}"; do
  sudo pacman -Rns --noconfirm "$package"
done

# Packages to install

INSTALL_PACKAGE=(
  ptyxis
  gnome-browser-connector
  resources
  gnome-tweaks
  dconf-editor
  obs-studio
  mpv
  inkscape
  chromium
  steam
  git
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  eyedropper
  npm
  ttf-opensans
)

for package in "${INSTALL_PACKAGE[@]}"; do
  sudo pacman -S --noconfirm "$package"
done

# Install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

INSTALL_PACKAGE_AUR=(
  visual-studio-code-bin
  brave-bin
  protonplus
  libre-menu-editor
  nautilus-open-any-terminal
  nautilus-code
)

for package in "${INSTALL_PACKAGE_AUR[@]}"; do
  yay -S --noconfirm "$package"
done

#nautilus any terminal setup
glib-compile-schemas /usr/share/glib-2.0/schemas

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal ptyxis

#Disable capslock
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"

#Set gdm monitor config
sudo cp "$HOME/.config/monitors.xml" /var/lib/gdm/.config/

#Set up git
git config --global user.name "ef"
git config --global user.email "33119700+sefaron@users.noreply.github.com"

#Set up brave
sudo mkdir -p /etc/brave/policies/managed/
sudo tee /etc/brave/policies/managed/GroupPolicy.json > /dev/null <<EOF
{
  "RestoreOnStartup": 1,
  "PasswordManagerEnabled": false,
  "PaymentMethodQueryEnabled": false,
  "AutofillCreditCardEnabled": false,
  "AutofillAddressEnabled": false,
  "ShowHomeButton": true,
  "BraveRewardsDisabled": true,
  "BraveWalletDisabled": true,
  "BraveVPNDisabled": 1,
  "BraveAIChatEnabled": false,
  "TorDisabled": true,
  "DnsOverHttpsMode": "automatic"
}
EOF

#install ms fonts

cd ~/Downloads/

git clone https://github.com/sefaron/ms-fonts.git

sudo mkdir /usr/local/share/fonts

sudo mv ms-fonts /usr/local/share/fonts

sudo fc-cache --force