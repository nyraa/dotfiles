#! /bin/bash

STEP=5
FADE=0
TIME=200

if [[ "$1" == "inc" ]];
then
    xbacklight -inc $STEP -steps $FADE -time $TIME
elif [[ "$1" == "dec" ]];
then
    xbacklight -dec $STEP -steps $FADE -time $TIME
fi
dunstify -h int:value:$(xbacklight -get) "Backlight" -a "xbacklight" -r 60001 -t 2000
