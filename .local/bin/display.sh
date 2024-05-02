#! /bin/bash

if [[ "$1" == "reset" ]];
then
    autorandr -l internal
else
    options=$(autorandr --list)

    selected_option=$(echo "$options" | rofi -dmenu -i -p "Select a display profile")

    if [ -n "$selected_option" ];
    then
        autorandr -l "$selected_option"
    else
        echo "Cancel"
    fi
fi
