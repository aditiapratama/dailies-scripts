#!/bin/sh
# auto update script for numix projects

: ${NUMIXGTK="$HOME/git/xfce4/Numix"}
: ${NUMIXICON="$HOME/git/xfce4/numix-icon-theme"}
: ${NUMIXICONCIRCLE="$HOME/git/xfce4/numix-icon-theme-circle"}
: ${NUMIXFOLDER="$HOME/git/xfce4/numix-folders"}
: ${HARDCODE="$HOME/git/xfce4/Hardcode-Tray"}
: ${XFCE4="$HOME/git/xfce4"}
: ${HARDCODEFIXER="$HOME/git/xfce4/hardcode-fixer"}
: ${OVERPASS="$HOME/git/fonts/overpass"}
: ${EGTK="$HOME/git/xfce4/egtk"}

  _update_all()
  {
    cd $NUMIXGTK
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    cd $NUMIXICON
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    cd $NUMIXICONCIRCLE
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    cd $NUMIXFOLDER
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    cd $HARDCODE
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    #cd $OVERPASS
    #git stash && git pull origin master --rebase
    cd $HARDCODEFIXER
    git clean -f && git stash && git fetch -p && git pull origin master --rebase
    #cd $EGTK
    #git-bzr pull
  }

  _build_numix_gtk()
  {
    cd $NUMIXGTK
    sudo chmod -R 777 .
    #exec >/dev/null 2>&1
    rm -rf /usr/share/themes/Numix/*
    sleep 2s
    echo "Old Numix Data removed"
    make
    make install
    sleep 2s
    echo "Numix GTK Updated"

  }

  _print_log()
  {
    cd $NUMIXGTK
    echo "### NUMIX-GTK LOGS ###" > $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    cd $NUMIXICON
    echo "" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    echo "### NUMIX-ICON LOGS ###" >> $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    cd $NUMIXICONCIRCLE
    echo "" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    echo "### NUMIX-ICON-CIRCLE LOGS ###" >> $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    cd $NUMIXFOLDER
    echo "" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    echo "### NUMIX-FOLDER LOGS ###" >> $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    cd $HARDCODE
    echo "" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    echo "### HARDCODE LOGS ###" >> $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    #cd $OVERPASS
    #echo "" >> $XFCE4/numix-logs.md
    #echo "" >> $XFCE4/numix-logs.md
    #echo "### OVERPASS LOGS ###" >> $XFCE4/numix-logs.md
    #echo "-------------------------------" >> $XFCE4/numix-logs.md
    #echo "" >> $XFCE4/numix-logs.md
    #git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    cd $HARDCODEFIXER
    echo "" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    echo "### HARDCODEFIXER LOGS ###" >> $XFCE4/numix-logs.md
    echo "-------------------------------" >> $XFCE4/numix-logs.md
    echo "" >> $XFCE4/numix-logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

    #cd $EGTK
    #echo "" >> $XFCE4/numix-logs.md
    #echo "" >> $XFCE4/numix-logs.md
    #echo "### EGTK LOGS ###" >> $XFCE4/numix-logs.md
    #echo "-------------------------------" >> $XFCE4/numix-logs.md
    #echo "" >> $XFCE4/numix-logs.md
    #git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $XFCE4/numix-logs.md

  }

  _hardcode_menu()
  {
    cd $HARDCODE && sudo -E python3 script.py
  }

  _hardcode_fixer_run()
  {
    cd $HARDCODEFIXER && sudo ./fix.sh
  }

  _view_log()
  {
      nano --softwrap $XFCE4/numix-logs.md
  }

  _numix_folder()
  {
    cd /opt/numix-folders && sudo ./numix-folders
  }
  _gtk_icon_update()
  {
	sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle
	sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle-Light
	sleep 3s
	echo "Icon Cache Updated"
  }

  _endkey()
  {
    echo -n "Press [enter] to exit"
    read END
  }

### UI ###
clear
echo "NUMIX-UPDATE"
echo "------------------------------------------------------------"
echo ""
echo "   (1) Update Numix"
echo "   (2) Hardcode Tray Fix"
echo "   (3) Hardcode Icon Fix"
echo "   (4) Numix Folder"
echo "   (5) View Logs"
echo "   (6) Exit"
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-3) then press [enter] :"
read mainmenu
echo " "
clear

  if [ "$mainmenu" = 1 ]; then
    _update_all
    _gtk_icon_update
    _build_numix_gtk
    _print_log
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _hardcode_menu
    _endkey

  elif [ "$mainmenu" = 3 ]; then
    _hardcode_fixer_run
    _endkey

  elif [ "$mainmenu" = 4 ]; then
    _numix_folder
    _endkey

  elif [ "$mainmenu" = 5 ]; then
    _view_log
    _endkey

  elif [ "$mainmenu" = 6 ]; then
    _endkey
    echo "Bye ! "

  else
  echo "the script couldn't understand your choice, try again...";

  fi;
