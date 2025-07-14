#!/bin/bash

# Install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd .. && rm -rf yay

INSTALL_PACKAGE_AUR=(
  bottles
  brave-bin
  extension-manager
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
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal ptyxis

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal use-generic-terminal-name true

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