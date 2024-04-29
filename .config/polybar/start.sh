#! /bin/bash

# terminate old polybar
# killall -q polybar

# wait for all polybar exits
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; killall -q polybar; done

minor_monitor=()

while IFS= read -r line;
do
    read -r -a words <<< "$line"
    monitor=${words[0]}
    if [[ "${words[2]}" == "primary" ]];
    then
        major_monitor=$monitor
    elif [[ "${words[1]}" == "connected" ]];
    then
        minor_monitor+=("$monitor")
    fi
done < <(xrandr -q | grep "connected")

for m in "${minor_monitor[@]}";
do
    MONITOR=$m polybar --reload second_top &
done

MONITOR=$major_monitor polybar --reload top_main &
