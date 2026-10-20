#!/usr/bin/env bash


opcion=$(printf "Apagar\nReiniciar\nSuspender\nHibernar" | fuzzel --dmenu -p "Power: ")


case "$opcion" in
    "Apagar") shutdown now ;;
    "Reiniciar") reboot ;;
    "Suspender") systemctl suspend ;;
    "Hibernar") systemctl hibernate ;;
esac
