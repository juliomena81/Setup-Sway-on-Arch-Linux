#!/bin/bash

if [ "$(nmcli -t -f TYPE,STATE dev | grep "wireguard:connected")" ]; then
    
    echo '{"text": "󰦝", "class": "connected", "tooltip": "Proton VPN Activa"}'
else
    
    echo '{"text": "󰦞", "class": "disconnected", "tooltip": "Sin protección VPN"}'
fi
