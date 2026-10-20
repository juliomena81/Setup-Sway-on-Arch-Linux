#!/bin/bash
STATUS=$(tr -d '[:space:]' < /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)

if [ "$1" == "switch" ]; then
    if [ "$STATUS" == "1" ]; then
        echo 0 | sudo /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null
        STATUS="0"
    else
        echo 1 | sudo /usr/bin/tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null
        STATUS="1"
    fi

    pkill -RTMIN+10 waybar
fi


if [ "$STATUS" == "1" ]; then
    echo "<span foreground='#8aa8a1'>󰑌</span>"
else
    echo "󱐋"
fi
