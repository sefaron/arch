#!/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Install Gnome Desktop Environment

sudo pacman -S --noconfirm gdm gnome-control-center gnome-backgrounds gnome-text-editor ptyxis nvidia-open

# Enable autostart of gdm

sudo systemctl enable gdm.service

# Apply nvidia hook for updates

sudo mkdir -p /etc/pacman.d/hooks/

sudo tee /etc/pacman.d/hooks/nvidia.hook > /dev/null <<EOF
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
# You can remove package(s) that don't apply to your config, e.g. if you only use nvidia-open you can remove nvidia-lts as a Target
Target=nvidia
Target=nvidia-open
Target=nvidia-lts
# If running a different kernel, modify below to match
Target=linux

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

# Packages to install

INSTALL_PACKAGE=(
  android-tools
  chromium
  dconf-editor
  decibels
  eyedropper
  fastfetch
  gnome-boxes
  gnome-browser-connector
  gnome-calculator
  gnome-characters
  gnome-disk-utility
  gnome-font-viewer
  gnome-tweaks
  inkscape
  loupe
  mpv
  npm
  obs-studio
  resources
  ttf-jetbrains-mono
  ttf-opensans
)

for package in "${INSTALL_PACKAGE[@]}"; do
  sudo pacman -S --noconfirm "$package"
done