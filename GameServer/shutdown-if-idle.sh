#!/bin/bash

shutdown_idle_seconds=3600

last_inactivity_time=`grep -P "(All clients disconnected, pausing game calendar)|(Server logger started)" /var/log/vintagestory-server/info.log \
        |awk '{print $1, $2, $3}' \
        |tail -1`
last_activity_time=`grep -P "A client reconnected, resuming game calendar" /var/log/vintagestory-server/info.log \
        |awk '{print $1, $2, $3}' \
        |tail -1`

seconds_since_inactivity=`dateutils.ddiff --input-format="%b %d %H:%M:%S" --format="%S" "$last_inactivity_time" now`
seconds_since_activity=`dateutils.ddiff --input-format="%b %d %H:%M:%S" --format="%S" "$last_activity_time" now`

if (( $seconds_since_inactivity < $seconds_since_activity ))
then
        echo No active clients $seconds_since_inactivity
        if (( $seconds_since_inactivity > $shutdown_idle_seconds ))
        then
                sudo shutdown now
        else
                echo No active clients $shutdown_idle_seconds seconds not elapsed \($seconds_since_inactivity\)
        fi
else
        echo Clients are active $seconds_since_inactivity seconds
fi