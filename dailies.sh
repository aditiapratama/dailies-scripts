#!/bin/bash
# create folder based on date

: ${DAILIES="/media/server/Dropbox/dailies"}

dailies() {

    foldername=$(date +%Y-%m-%d)
    mkdir -p $DAILIES/$foldername/{aditia,ramdhan,firman,bintang,adhi,fandi,nirwan,chaerul,asep,fuad,riskal,luki,iza}

}

case "$1" in
  mkdir)
    dailies
    ;;

    *)
    echo "Usage: /etc/init.d/dailies.sh {mkdir}"
    exit 1
esac
exit 0
