#!/bin/bash

: ${XFCE4="/home/aditia/git/xfce4"}
#curdir=$(pwd)

_update_all()
{
	  #cd "$XFCE4"
		for f in "$XFCE4"/*;
  			do
     			[ -d "$f" ] && cd "$f" && echo Entering into "$f" and updating packages && git stash && git pull
  			done;
}

_print_log()
{
		cd "$XFCE4"
		for f in "$XFCE4"/*:
				do
					[ -d "$f" ] && cd "$f" &&\
					echo "" > $XFCE4/log/log.md &&\
					echo "### LOGS ###" >> $XFCE4/log/log.md &&\
					echo "-------------------------------" >> $XFCE4/log/log.md &&\
					echo "" >> $XFCE4/log/log.md &&\ 
					git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $XFCE4/log/log.md
				done;
}

_view_log()
{
	cd $XFCE4
	nano --softwrap log.md
}


_endkey()
{
		echo -n "Press [enter] to exit"
    read END
}


### run de skript
_update_all
#_print_log
_endkey
