#!/bin/sh

function restart_plasmashell() {
    kquitapp5 plasmashell
    kstart5 plasmashell
}

function set_to_1600_900() {
    SCREEN_NAME=$(xrandr | grep connected | grep -v disconnected | awk '{print $1}')
    xrandr --output $SCREEN_NAME --scale-from 1600x900 --panning 1600x900
    restart_plasmashell
}

function reset_scaling() {
    SCREEN_NAME=$(xrandr | grep connected | grep -v disconnected | awk '{print $1}')
    xrandr --output SCREEN_NAME --scale 1x1
    restart_plasmashell
}

if [ "$1" = "set" ]; then
    set_to_1600_900
elif [ "$1" = "reset" ]; then
    reset_scaling
else
    echo "Usage: $0 [set|reset]"
fi

