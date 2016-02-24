    #!/bin/sh
    #
    #: Title       : Krita-update
    #: Author      : David REVOY < info -at- davidrevoy.com >
    #: License     : GPL
    #  version 1.2


    ########
    # CORE #
    ########

    # CPU available
    numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

    _update_sources()
    {
        cd $HOME/kde4/src/calligra && git pull && echo "### KRITA LOGS ###" > $HOME/kde4/logs.md
        echo "-------------------------------" >> $HOME/kde4/logs.md
        echo "" >> $HOME/kde4/logs.md
        git log --pretty=format:"%cn | committed %h | %s |  on %cr" -20 >> $HOME/kde4/logs.md
    }

    _configure_and_build_sources()
    {
        cd $HOME/kde4/build/calligra
        make -j$numCores
        make install -j$numCores
        #exec >/dev/null 2>&1
        #kbuildsycoca4
        notify-send -t 2000 -i calligrakrita "Compiling Krita" "Done :D"
    }

    _view_log()
    {
        nano --softwrap $HOME/kde4/logs.md
    }

    _endkey()
    {
        echo -n "Press [enter] to exit"
        read END
    }


    #######
    # UI  #
    #######

    clear
    echo "KRITA-UPDATE"
    echo "------------------------------------------------------------"
    echo ""
    echo "   (1) Update Krita & compile"
    echo "   (2) Update only"
    echo "   (3) Compile only"
    echo "   (4) View log only"
    echo "   (5) Exit"
    echo ""
    echo "------------------------------------------------------------"
    echo -n "               Enter your choice (1-4) then press [enter] :"
    read mainmenu
    echo " "
    clear

        if [ "$mainmenu" = 1 ]; then
            _update_sources
            _configure_and_build_sources
            _view_log
            _endkey

        elif [ "$mainmenu" = 2 ]; then
            _update_sources
            _view_log
            _endkey

        elif [ "$mainmenu" = 3 ]; then
	        _configure_and_build_sources
            _view_log
            #xdg-open http://www.davidrevoy.com/article193/
            _endkey

        elif [ "$mainmenu" = 4 ]; then
            _view_log
            _endkey

        elif [ "$mainmenu" = 5 ]; then
            echo "Bye ! "

        else
        echo "the script couldn't understand your choice, try again...";

        fi;
