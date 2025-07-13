#!/bin/bash

# Update system
sudo pacman -Syyu --noconfirm

# Install Gnome Desktop Environment

sudo pacman -Syu --noconfirm gnome-shell gdm gnome-control-center gnome-backgrounds ptyxis nvidia-open

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
  chromium
  dconf-editor
  decibels
  eyedropper
  fastfetch
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
  resources
  ttf-jetbrains-mono
  ttf-opensans
)

for package in "${INSTALL_PACKAGE[@]}"; do
  sudo pacman -S --noconfirm "$package"
done

# Install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd .. && rm -rf yay

INSTALL_PACKAGE_AUR=(
  brave-bin
  libre-menu-editor
  nautilus-code
  nautilus-open-any-terminal
  protonplus
  visual-studio-code-bin
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

sudo tee "$HOME/.config/monitors.xml" > /dev/null <<EOF
<monitors version="2">
  <configuration>
    <layoutmode>physical</layoutmode>
    <logicalmonitor>
      <x>3840</x>
      <y>0</y>
      <scale>1</scale>
      <monitor>
        <monitorspec>
          <connector>HDMI-1</connector>
          <vendor>MSI</vendor>
          <product>MSI MP225</product>
          <serial>PC6M075103937</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>100.000</rate>
        </mode>
      </monitor>
    </logicalmonitor>
    <logicalmonitor>
      <x>1920</x>
      <y>0</y>
      <scale>1</scale>
      <primary>yes</primary>
      <monitor>
        <monitorspec>
          <connector>DP-1</connector>
          <vendor>MSI</vendor>
          <product>MSI MAG241CR</product>
          <serial>0x00000054</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>143.855</rate>
        </mode>
      </monitor>
    </logicalmonitor>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <scale>1</scale>
      <monitor>
        <monitorspec>
          <connector>DP-2</connector>
          <vendor>XMI</vendor>
          <product>Redmi 215 NF</product>
          <serial>4241712Z9111D</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60.000</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  </configuration>
</monitors>
EOF

sudo mkdir -p /var/lib/gdm/.config

sudo cp "$HOME/.config/monitors.xml" /var/lib/gdm/.config/

#Set up git
git config --global user.name "ef"
git config --global user.email "33119700+sefaron@users.noreply.github.com"

#Set up brave
sudo mkdir -p /etc/brave/policies/managed/
sudo tee /etc/brave/policies/managed/GroupPolicy.json > /dev/null <<EOF
{
  "AutofillAddressEnabled": false,
  "AutofillCreditCardEnabled": false,
  "BraveAIChatEnabled": false,
  "BraveNewsDisabled": 1,
  "BraveRewardsDisabled": true,
  "BraveSpeedreaderDisabled": 1,
  "BraveTalkDisabled": 1,
  "BraveVPNDisabled": 1,
  "BraveWalletDisabled": true,
  "BraveWaybackMachineDisabled": 1,
  "DnsOverHttpsMode": "automatic",
  "PasswordManagerEnabled": false,
  "PaymentMethodQueryEnabled": false,
  "RestoreOnStartup": 1,
  "ShowHomeButton": true,
  "TorDisabled": true
}
EOF

#install ms fonts

mkdir -p ~/Downloads && cd ~/Downloads

git clone https://github.com/sefaron/ms-fonts.git

sudo mkdir -p /usr/local/share/fonts

sudo mv ms-fonts /usr/local/share/fonts

sudo fc-cache --force