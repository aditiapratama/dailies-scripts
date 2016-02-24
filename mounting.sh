#!/bin/sh

# first make directory
mkdir -p /media/server
mkdir -p /media/gerbang

# change ownership
sudo chmod -R 777 /media/server
sudo chmod -R 777 /media/gerbang

# make sure cifs installed
sudo apt-get install cifs-utils

# add these lines to /etc/fstab
echo "# server kms
//192.168.0.100/server  /media/server  cifs  username=patopo,password=patopos,iocharset=utf8,sec=ntlm  0  0
# gerbang kms
//192.168.0.100/gerbang  /media/gerbang  cifs  guest,auto,uid=1000,iocharset=utf8,sec=ntlm  0  0" >> /etc/fstab

# mounting
sudo mount -a

# Done
echo done
