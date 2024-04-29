#!/bin/bash

timestamp=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
screenshot_saveto="~/Pictures/screenshots"
screenrecord_saveto="~/Videos/screenrecords"

eval mkdir -p $screenshot_saveto
eval mkdir -p $screenrecord_saveto

eval screenshot_path="${screenshot_saveto}/Screenshot_${timestamp}.png"
eval screenrecord_path="${screenrecord_saveto}/Record_${timestamp}.webm"

action_type=$1
mode=$2
dest=$3

case $action_type in
screenshot)
    case $dest in
    file)
        case $mode in
        full)
            ffcast -f png "$screenshot_path"
            desc="Screen"
            ;;
        select)
            maim -su "$screenshot_path"
            desc="Selected region"
            ;;
        currwindow)
            maim -i $(xdotool getactivewindow) "$screenshot_path"
            desc="Current window"
            ;;
        esac
        notify-send "Screenshot" "$desc captured to $screenshot_path"
        ;;
    clip)
        case $mode in
        full)
            maim -u | xclip -selection clipboard -t image/png
            desc="Screen"
            ;;
        select)
            maim -su | xclip -selection clipboard -t image/png
            desc="Selected region"
            ;;
        currwindow)
            maim -ui $(xdotool getactivewindow) | xclip -selection clipboard -t image/png
            desc="Current window"
            ;;
        esac
        notify-send "Screenshot" "$desc copy to clipboard"
        ;;
    esac
    ;;
screenrecord)
    # find existed ffcast pid
    ffcast_pids=$(pgrep -f ffcast)
    record_flag=0
    if [ -z "$ffcast_pids" ];
    then
        # no ffcast found, start record
        record_flag=1 
    else
        # find ffcast pid
        for pid in $ffcast_pids; do
            ffmpeg_pids=$(ps --ppid $pid -o pid,comm | grep ffmpeg | awk '{print $1}')
            if [ ! -z "$ffmpeg_pids" ];
            then
                ffmpeg_pid=$ffmpeg_pids
            fi
        done
    fi

    if [ $record_flag == 1 ] || [ -z $ffmpeg_pid ];
    then
        # start recording
        echo start
        case $mode in
            select)
                # includes select window
                ffcast -fw rec "$screenrecord_path"
                ;;
            currwindow)
                ffcast -f# "$(xdotool getactivewindow)" rec "$screenrecord_path"
                ;;
            full)
                ffcast -f rec "$screenrecord_path"
                ;;
        esac
    else
        echo stop
        kill $ffmpeg_pid
        description="Screenrecord terminated"
    fi
    ;;
*)
    echo Unknown action    
esac
