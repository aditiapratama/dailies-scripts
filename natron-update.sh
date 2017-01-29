	#!/bin/sh
    #
    #: Title       : Natron-update
    #: Author      : Aditia A. Pratama < aditia -dot- ap -at- gmail.com >
    #: License     : GPL
    #  version 1.0

    ########
    # CORE #
    ########
    numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

    _update_sources()
    {
    	# Natron Folder
    	cd $HOME/natron-git/Natron
    	git pull
    	git submodule update -i --recursive
    }

     _update_view_log()
    {
    	cd $HOME/natron-git/Natron && echo "Current Branch : " > $HOME/natron-git/log.md
    	git branch --column >> $HOME/natron-git/log.md
    	echo "" >> $HOME/natron-git-git/log.md
    	echo "### NATRON LOGS ###" >> $HOME/natron-git-git/log.md
      echo "-------------------------------" >> $HOME/natron-git/log.md
      echo "" >> $HOME/natron-git/log.md
      git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $HOME/natron-git/log.md
    }
