#!/usr/bin/bash

export PATH=$HOME/.local/bin:$PATH

xrandr -s 1920x1080
wal -R

echo "no" > $HOME/.cache/wmExit
slstatus &
picom &
clipmenud &
dunst &
#systemctl status {systemd-networkd,systemd-resolved,networking,NetworkManager,systemd-hostnamed,openvpn} |egrep -v 'man:|http'
#systemctl disable --now networking.service
#systemctl restart NetworkManager.service
wallpaperChangePywal

while true
do
    wmExit=$(cat $HOME/.cache/wmExit)
    if [ $wmExit = "yes" ]
    then
        exit
    else
        dwm ;
    fi
done
