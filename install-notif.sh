#!/bin/sh
USERNAME=$(hostname -f)

sudo cp /media/server/notification.sh /etc/init.d/
sudo chmod +x /etc/init.d/notification.sh
sudo chown 755 /etc/init.d/notification.sh

crontab -l | { cat; echo "0 16,17,18 * * 1-5 /etc/init.d/notification.sh"; } | crontab -
echo "# Allow use of zenity in cron jobs (xhost controls user access to the X server)
xhost local:"$USERNAME" > /dev/null" >> $HOME/.bashrc
