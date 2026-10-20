#!/bin/bash

case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    *)
        echo "uso: $0 {up|down|mute}" >&2
        exit 1 ;;
esac
