#!/bin/sh
#
#: Title       : Blender-update
#: Author      : Aditia A. Pratama < aditia -dot- ap -at- gmail.com >
#: License     : GPL
#  version 1.0

: ${COMMITFILE=$HOME"/git/projects/aditia_blog/content/pages/commit-logs.md"}
: ${BLENDER="/home/aditia/blender-git/blender"}
: ${MASTERBUILD="/home/aditia/blender-git/build_master/"}
: ${BETABUILD="/home/aditia/blender-git/build_beta/"}
: ${MODULEBUILD="/home/aditia/blender-git/build_module/"}
: ${BLENDER28="/home/aditia/blender-git/blender28"}
: ${BAM="/home/aditia/blender-git/blender-asset-manager"}
: ${FLAMENCO="/home/aditia/blender-git/flamenco"}
: ${DOCS="/home/aditia/blender-git/blender_docs"}
: ${ADDONSGIT="/home/aditia/blender-git/git-addons"}


    ########
    # CORE #
    ########

     BLENDER_VERSION="2.78"
    _update_sources()
    {
        #Blender Main & Submodule Update
        cd $BLENDER
        git stash
	      git fetch -p
        git pull --rebase
        git submodule foreach git pull --rebase origin master

        cd $BLENDER28
        git stash
	      git fetch -p
        git pull --rebase
        git submodule foreach git pull --rebase origin master

        #Blender extra updates
        # cd $HOME/blender-git/git-addons/animation-nodes && git stash && git fetch -p && git pull
        cd $BAM && git stash &&  git fetch -p && git pull --rebase
        cd $FLAMENCO && git stash && git fetch -p && git pull --rebase
        cd $DOCS && svn update
    }

    _update_addon_from_git()
    {
        cd $ADDONSGIT && ./git-pull-all.sh
        vim ./logs.md
    }

    _update_env()
    {
        cd $BLENDER/build_files/build_environment/
        ./install_deps.sh  --build-all --skip-openvdb
    }

    _build_manual()
    {
        cd $DOCS 
	make clean
	make html
        notify-send -t 2000 -i blender "Compiling Blender Docs" "Done!"
    }

    _view_manual()
    {
        cd $DOCS && xdg-open build/html/contents.html
    }

    _update_commit_logs()
    {
      cd $BLENDER
      BRANCH=$(git symbolic-ref --short -q HEAD)
      NOW=$(date -R)
echo 'title: Commit Logs

<h2 style="border-bottom: 3px solid #cfd8dc; padding-bottom:15px;">
  <i class="bf-blender"></i> BLENDER - BRANCH :
  <i style="text-transform:uppercase;color:#c7254e">'$BRANCH'</i>
  <span style="font-size:16px;font-weight:200;float:right;"> Compiled :
    <time class="timeago" datetime="'$NOW'">'$NOW'</time>
  </span>
</h2>

AUTHOR | HASH | MESSAGE
--- | --- | ---' > $COMMITFILE
      git log --pretty=format:'%cn | [`%h`](https://developer.blender.org/rB%h) | %s' -20 >> $COMMITFILE
      cd $HOME/git/projects/aditia_blog
      if output=$(git status --porcelain) && [ -z "$output" ]; then
        # Working directory clean
        make github
      else
        # Uncommitted changes
        # git diff --exit-code
        git commit -am "updated blender commit logs"
        git push
        make github
      fi
    }

    _update_view_log()
    {
        cd $BLENDER
        branchname=$(git symbolic-ref --short -q HEAD)
        echo "# Current Branch : ![alt text][logo] *$branchname*" > $HOME/blender-git/log.md
        echo '[logo]: file:///home/aditia/blender-git/blender_48.png "Logo Blender"' >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BLENDER " >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -30 >> $HOME/blender-git/log.md

        cd $BLENDER28 && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BLENDER 2.8 " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $BLENDER/release/scripts/addons/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### ADDONS " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $BLENDER/release/scripts/addons_contrib/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### ADDONS CONTRIB" >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $BAM && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BAM " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $FLAMENCO && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### FLAMENCO " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $HOME/blender-git/log.md

        cd $DOCS && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BLENDER MANUAL " >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "rev | user | date | time | comment " >> $HOME/blender-git/log.md
        echo "--- | --- | --- | --- | ---" >> $HOME/blender-git/log.md
        svn log -l15 | ../svn_short_log >> $HOME/blender-git/log.md
    }

    _view_log()
    {
	markdown2 -x tables $HOME/blender-git/log.md > $HOME/blender-git/log.html
        xdg-open $HOME/blender-git/log.html
    }

    _configure_and_build_master()
    {
        cd $MASTERBUILD
        make -j4 && make install -j4
        notify-send -t 2000 -i blender "Compiling Blender Master Branch" "Done!"
    }

    _configure_and_build_module()
    {
        cd $MODULEBUILD
        make && make install
        notify-send -t 2000 -i blender "Compiling Blender Python Module" "Done :D"
    }

    _configure_and_build_28()
    {
        cd $BETABUILD
        make && make install
        notify-send -t 2000 -i blender "Compiling Blender 2.8 Branch" "Done :D"
    }

    _check_branch()
    {
        cd $BLENDER
        git branch
    }

    _gitg()
    {
        cd $BLENDER && gitg
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
    echo "BLENDER-UPDATE"
    echo "------------------------------------------------------------"
    echo ""
    echo "   (1) Update All Repo & compile master branch"
    echo "   (2) Compile Master Branch only"
    echo "   (3) Compile Python Module only"
    echo "   (4) Compile Blender 2.8 only"
    echo "   (5) Update only"
    echo "   (6) Update addons from git"
    echo "   (7) Update Deps"
    echo "   (8) view log "
    echo "   (9) Exit"
    echo ""
    echo "------------------------------------------------------------"
    echo -n "               Enter your choice (1-4) then press [enter] :"
    read mainmenu
    echo " "
    clear

        if [ "$mainmenu" = 1 ]; then
            _update_sources
            _configure_and_build_master
            #_configure_and_build_module
            #_configure_and_build_28
            _build_manual
            _update_view_log
            _view_log
            _endkey

        elif [ "$mainmenu" = 2 ]; then
            _configure_and_build_master
            _view_log
            _endkey

        elif [ "$mainmenu" = 3 ]; then
            _configure_and_build_module
            _view_log
            _endkey

        elif [ "$mainmenu" = 4 ]; then
            _configure_and_build_28
            _view_log
            _endkey

        elif [ "$mainmenu" = 5 ]; then
            _update_sources
            _update_view_log
            #_update_commit_logs
            _view_log
            _endkey

        elif [ "$mainmenu" = 6 ]; then
            _update_addon_from_git
            _endkey

        elif [ "$mainmenu" = 7 ]; then
            _update_env
            _endkey

        elif [ "$mainmenu" = 8 ]; then
            _update_view_log
            _view_log
            _endkey

        elif [ "$mainmenu" = 9 ]; then
            echo "Bye ! "

        else
        echo "the script couldn't understand your choice, try again...";

        fi;
