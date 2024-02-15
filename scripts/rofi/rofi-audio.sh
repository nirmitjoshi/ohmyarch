#!/bin/bash

# Get the available sinks using pactl
sinks=$(pactl list sinks | grep 'Name: ' | awk -F'Name: ' '{print $2}')

pamixer --allow-boost


# Prompt the user to select an action using rofi
action=$(echo -e "Change Volume\nChange Output Device" | rofi -dmenu -i -p "Select Action:")

case "$action" in
    "Change Volume")
        # Get the current volume level
        current_volume=$(pamixer --get-volume-human)

        # Prompt the user to input the volume change amount using rofi
        volume_change=$(rofi -dmenu -i -p "$current_volume Change to:")

        # Set the new volume level using pamixer
        pamixer --set-volume $volume_change
        dunstify -a "changevolume" -u normal -r 9993 "Volume set to: ${volume_change}%" -t 2000

        ;;
    "Change Output Device")
        # Prompt the user to select an output device using rofi
        selected_sink=$(echo "$sinks" | rofi -dmenu -i -p "Select Output Device:")

        # Set the selected sink as the default sink using pactl
        pactl set-default-sink "$selected_sink"
        ;;
esac

