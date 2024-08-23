#!/bin/bash


get_max_rate_monitor() {
    MONITOR_NAME=$1
    xrandr -q | grep $MONITOR_NAME -A1 | tail -n1 | awk -F'+' '{ print $2 }' | awk '{ print $1 }'
}

get_max_resolution_monitor() {
    MONITOR_NAME=$1
    xrandr -q | grep $MONITOR_NAME -A1 | tail -n1 | awk -F'+' '{ print $1 }' | awk '{ print $1 }'
}

MONITORS=`xrandr | grep -w connected | cut -d' ' -f-1`
MONITORS_OFF=`xrandr | grep -w disconnected | cut -d' ' -f-1`


LEFT_MONITOR=$1
SWAP_MONITOR=$2
if [ $LEFT_MONITOR -z ]
then
    LEFT_MONITOR=eDP-1
fi

QUANTITY_MONITORS=`echo $MONITORS | wc -w`

for monitor in `echo "$MONITORS_OFF"`
do
    xrandr --output $monitor --off
done

for monitor in `echo "$MONITORS"`
do
    xrandr --output $monitor --rate `get_max_rate_monitor $monitor` --mode `get_max_resolution_monitor $monitor`
done

killall polybar
if [[ $QUANTITY_MONITORS -eq 3 ]]
then
    MIDDLE_MONITOR=`echo $MONITORS | awk '{ print $2 }'`
    RIGHT_MONITOR=`echo $MONITORS | awk '{ print $3 }'`
    if [ ! $SWAP_MONITOR -z ]
    then
        MIDDLE_MONITOR=`echo $MONITORS | awk '{ print $3 }'`
        RIGHT_MONITOR=`echo $MONITORS | awk '{ print $2 }'`
    fi

    xrandr --output $LEFT_MONITOR --left-of $MIDDLE_MONITOR
    xrandr --output $RIGHT_MONITOR --right-of $MIDDLE_MONITOR
    MONITOR=$LEFT_MONITOR polybar --reload example &
    MONITOR=$MIDDLE_MONITOR polybar --reload example2 &
    MONITOR=$RIGHT_MONITOR polybar --reload example3 &
elif [[ $QUANTITY_MONITORS -eq 2 ]]
then
    MIDDLE_MONITOR=`echo $MONITORS | awk '{ print $2 }'`
    xrandr --output $LEFT_MONITOR --left-of $MIDDLE_MONITOR
    MONITOR=$LEFT_MONITOR polybar --reload example &
    MONITOR=$MIDDLE_MONITOR polybar --reload example2 &
else
    MONITOR=$LEFT_MONITOR polybar --reload example2 &
fi
