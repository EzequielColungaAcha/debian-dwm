#!/usr/bin/bash

export PATH=$HOME/.local/bin:$PATH

xrandr -s 1920x1080
wal -R

echo "no" > $HOME/.cache/wmExit
slstatus &
picom &
clipmenud &
nm-applet &

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