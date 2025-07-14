#!/bin/bash

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

#install ms fonts

mkdir -p ~/Downloads && cd ~/Downloads

curl -LO https://github.com/sefaron/ms-fonts/archive/refs/heads/main.zip

unzip main.zip

sudo mkdir -p /usr/local/share/fonts

sudo mv ms-fonts-main /usr/local/share/fonts

sudo fc-cache --force