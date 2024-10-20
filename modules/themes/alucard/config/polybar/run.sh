#!/usr/bin/env bash

pkill -u $UID -x polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#polybar main >$XDG_DATA_HOME/polybar.log 2>&1 &
#echo 'Polybar launched...'


## https://github.com/polybar/polybar/issues/763
#for m in $(polybar --list-monitors | cut -d":" -f1); do
#    MONITOR=$m polybar --reload bar1 >$XDG_DATA_HOME/polybar_$m.log 2>&1 &
#    MONITOR=$m polybar --reload bar2 >$XDG_DATA_HOME/polybar_$m.log 2>&1 &
#done

COMPUTERNAME=$(hostname)

if [ $DUALMONITOR == "yes" ]; then
    if [ $COMPUTERNAME == "magic" ]; then
        MONITOR="DP1" DPI=168 LAN="wlp0s20f0u13" polybar --reload primary >$XDG_DATA_HOME/polybar_primary.log 2>&1 &
        MONITOR="DP2" polybar --reload next >$XDG_DATA_HOME/polybar_next.log 2>&1 &
    elif [ $COMPUTERNAME == "eniac" ]; then
        MONITOR="HDMI-A-2" DPI=168 LAN="enp5s0" polybar --reload primary >$XDG_DATA_HOME/polybar_primary.log 2>&1 &
        MONITOR="HDMI-A-1" DPI=168 polybar --reload next >$XDG_DATA_HOME/polybar_next.log 2>&1 &
    fi
else
    if [ $COMPUTERNAME == "yoga" ]; then
        MONITOR="eDP" DPI=168 LAN="wlp1s0" polybar --reload primary >$XDG_DATA_HOME/polybar_primary.log 2>&1 &
    elif [ $COMPUTERNAME == "TenSunnyDay" ]; then
        MONITOR="eDP-1" DPI=120 LAN="wlp0s20f3" polybar --reload primary >$XDG_DATA_HOME/polybar_primary.log 2>&1 &
    fi
fi
