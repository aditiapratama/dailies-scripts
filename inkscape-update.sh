#!/bin/sh
#script for auto-compile inkscape-master

# Get CPU Available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`/2))

_update_source()
{
    #update the source code
    cd $HOME/inkscape-src/inkscape
    git fetch  && git pull
}

_update_log()
{
    #print the log
    cd $HOME/inkscape-src/inkscape
    branchname=$(git symbolic-ref --short -q HEAD)
    echo "# Current Branch : ![alt text][logo] *$branchname*" > $HOME/inkscape-src/logs.md
    echo '[logo]: file:///opt/inkscape/share/icons/hicolor/48x48/apps/inkscape.png "Logo Inkscape"' >> $HOME/inkscape-src/logs.md
    echo "" >> $HOME/inkscape-src/logs.md
    echo "### INKSCAPE LOGS ###" >> $HOME/inkscape-src/logs.md
    echo "" >> $HOME/inkscape-src/logs.md
    echo "user | hash | comment | time" >> $HOME/inkscape-src/logs.md
    echo "--- | --- | --- | ---" >> $HOME/inkscape-src/logs.md
    git log --pretty=format:"%cn | %h | %s | %cr" -25 >> $HOME/inkscape-src/logs.md
}

_view_log()
{
    nano --softwrap $HOME/inkscape-src/logs.md
}

_compile_inkscape()
{
    cd $HOME/inkscape-src/build-linux/
    make -j$numCores
    make install -j$numCores
    notify-send -t 2000 -i inkscape "Compiling Inkscape" "Done"
}

_endkey()
{
    echo -n "Press [enter] to exit"
    read END
}

### UI ###
clear
echo "INKSCAPE-UPDATE"
echo "------------------------------------------------------------"
echo ""
echo "   (1) Update & Compile Inkscape Source"
echo "   (2) Update Only Inkscape Source"
echo "   (3) Compile Only Inkscape Source"
echo "   (4) View logs"
echo "   (5) Exit"
echo ""
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-6) then press [enter] :"
read mainmenu
echo " "
clear

  if [ "$mainmenu" = 1 ]; then
    _update_source
    _update_log
    _compile_inkscape
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _update_source
    _update_log
    _view_log
    _endkey

  elif [ "$mainmenu" = 3 ]; then
    _compile_inkscape
    _view_log
    _endkey

  elif [ "$mainmenu" = 4 ]; then
    _view_log
    _endkey

  elif [ "$mainmenu" = 5 ]; then
    _endkey

  else
        echo "the script couldn't understand your choice, try again...";

  fi;
