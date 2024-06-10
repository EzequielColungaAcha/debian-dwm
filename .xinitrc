#!/usr/bin/bash

export PATH=$HOME/.local/bin:$PATH

wal -R
xrandr -s 1920x1080

echo "no" > $HOME/.cache/wmExit
slstatus &
picom &
clipmenud &

while true
do

    wmExit=$(cat $HOME/.cache/wmExit)
    if [ $wmExit = "yes" ]
    then
        exit
    else
        # np-applet &
        dwm ;
    fi
done
