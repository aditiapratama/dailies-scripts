#!/bin/bash

_restart_lightdm() {
    (
        exec >/dev/null 2>&1
        sudo service lightdm stop
        sudo lightdm start
        #startx
    )
    echo "Lightdm has been restarted"
}

#_bumblebeed_daemon() {
#    pid=`sudo pgrep -f "bumblebeed"`
#    if [ "$pid" ]; then
#       echo "Bumblebee daemon running"
#    else
#       exec >/dev/null 2>&1
#       sudo bumblebeed &
#       echo "Starting Bumblebee daemon"
#    fi

#   sleep 2
#   sudo service bumblebeed restart
#   echo "Bumblebee daemon started"
#}

#_bumblebeed_daemon
_restart_lightdm
