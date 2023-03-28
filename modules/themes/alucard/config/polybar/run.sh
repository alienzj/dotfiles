#!/usr/bin/env bash

pkill -u $UID -x polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#polybar main >$XDG_DATA_HOME/polybar.log 2>&1 &
#echo 'Polybar launched...'


## https://github.com/polybar/polybar/issues/763
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload bar1 >$XDG_DATA_HOME/polybar_$m.log 2>&1 &
    MONITOR=$m polybar --reload bar2 >$XDG_DATA_HOME/polybar_$m.log 2>&1 &
done
