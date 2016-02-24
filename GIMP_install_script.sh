#!/bin/sh
#script for auto-compile gimp-master

# Get CPU Available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

_export_path()
{
    export INSTALL_PREFIX=/opt/gimp
    export SRC_DIR=/home/aditia/gimp-git/gimp

    export PATH=$INSTALL_PREFIX/bin:$PATH
    export PKG_CONFIG_PATH=$INSTALL_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
    export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib:$LD_LIBRARY_PATH
}

_update_source()
{
    #update the source code
    cd $HOME/gimp-git/babl/ && git pull && echo "### BABL LOGS ###" > $HOME/gimp-git/logs.md
    echo "-------------------------------" >> $HOME/gimp-git/logs.md
    echo "" >> $HOME/gimp-git/logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $HOME/gimp-git/logs.md

    cd $HOME/gimp-git/gegl/ && git pull && echo "" >> $HOME/gimp-git/logs.md
    echo "" >> $HOME/gimp-git/logs.md
    echo "### GEGL LOGS ###" >> $HOME/gimp-git/logs.md
    echo "-------------------------------" >> $HOME/gimp-git/logs.md
    echo "" >> $HOME/gimp-git/logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $HOME/gimp-git/logs.md

    cd $HOME/gimp-git/gimp/ && git pull && echo "" >> $HOME/gimp-git/logs.md
    echo "" >> $HOME/gimp-git/logs.md
    echo "### GIMP LOGS ###" >> $HOME/gimp-git/logs.md
    echo "-------------------------------" >> $HOME/gimp-git/logs.md
    echo "" >> $HOME/gimp-git/logs.md
    git log --pretty=format:"%cn | committed %h | %s |  on %cr" -5 >> $HOME/gimp-git/logs.md

}

_view_log()
{
    nano --softwrap $HOME/gimp-git/logs.md
}

_compile_babl()
{
    cd $HOME/gimp-git/babl/ && ./autogen.sh --prefix=INSTALL_PREFIX
    make -j$numCores
    make install -j$numCores
    notify-send -t 2000 -i gimp "Compiling BABL" "Done"
}

_compile_gegl()
{
    cd $HOME/gimp-git/gegl/ && ./autogen.sh --prefix=INSTALL_PREFIX
    make -j$numCores
    make install -j$numCores
    notify-send -t 2000 -i gimp "Compiling GEGL" "Done"
}

_compile_gimp()
{
    cd $HOME/gimp-git/gimp/ && ./autogen.sh --prefix=INSTALL_PREFIX
    make -j$numCores
    make install -j$numCores
    notify-send -t 2000 -i gimp "Compiling GIMP" "Done"
}

_run_gimp()
{
    cd $HOME/gimp-git/ && sh run-gimp.sh
}
_endkey()
{
    echo -n "Press [enter] to exit"
    read END
}

### UI ###
clear
echo "GIMP-UPDATE"
echo "------------------------------------------------------------"
echo ""
echo "   (1) Update BABL, GEGL, & GIMP"
echo "   (2) Compile BABL Only"
echo "   (3) Compile GEGL Only"
echo "   (4) Compile GIMP Only"
echo "   (5) Compile BABL, GEGL & GIMP"
echo "   (6) View logs"
echo "   (7) Update sources and view logs"
echo "   (8) Run Gimp"
echo "   (9) Exit"
echo ""
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-8) then press [enter] :"
read mainmenu
echo " "
clear

        if [ "$mainmenu" = 1 ]; then
            _export_path
            _update_source
            _endkey

        elif [ "$mainmenu" = 2 ]; then
            _export_path
            _compile_babl
            _endkey

        elif [ "$mainmenu" = 3 ]; then
            _export_path
            _compile_gegl
            _endkey

        elif [ "$mainmenu" = 4 ]; then
            _export_path
            _compile_gimp
            _endkey

        elif [ "$mainmenu" = 5 ]; then
            _export_path
            _compile_bebl
            _compile_gegl
            _compile_gimp
            _endkey

        elif [ "$mainmenu" = 6 ]; then
            _view_log
            _endkey

        elif [ "$mainmenu" = 7 ]; then
            _export_path
            _update_source
            _view_log
            _endkey

        elif [ "$mainmenu" = 8 ]; then
            _run_gimp
            _endkey

        elif [ "$mainmenu" = 9 ]; then
            echo "Bye ! "

        else
        echo "the script couldn't understand your choice, try again...";

        fi;
