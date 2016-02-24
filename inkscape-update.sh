#!/bin/sh
#script for auto-compile inkscape-master

# Get CPU Available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

_update_source()
{
    #update the source code
    cd $HOME/inkscape-src/inkscape && git-bzr pull && echo "### INKSCAPE LOGS ###" > $HOME/inkscape-src/logs.md
    echo "-------------------------------" >> $HOME/inkscape-src/logs.md
    echo "" >> $HOME/inkscape-src/logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -25 >> $HOME/inkscape-src/logs.md
}

_view_log()
{
    nano --softwrap $HOME/inkscape-src/logs.md
}

_compile_inkscape()
{
    cd $HOME/inkscape-src/inkscape/ #&& ./autogen.sh --prefix=INSTALL_PREFIX
    make -j2
    make install -j2
    notify-send -t 2000 -i Inkscape "Compiling Inkscape" "Done"
}

_run_inkscape()
{
    cd $HOME/inkscape-src/ && sh run-inkscape.sh
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
echo "   (5) Run Inkscape"
echo "   (6) Exit"
echo ""
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-6) then press [enter] :"
read mainmenu
echo " "
clear

  if [ "$mainmenu" = 1 ]; then
    _update_source
    _compile_inkscape
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _update_source
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
    _run_inkscape
    _endkey

  elif [ "$mainmenu" = 5 ]; then
    _endkey

  else
        echo "the script couldn't understand your choice, try again...";

  fi;
