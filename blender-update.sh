#!/bin/sh
#
#: Title       : Blender-update
#: Author      : Aditia A. Pratama < aditia -dot- ap -at- gmail.com >
#: License     : GPL
#  version 1.0

: ${COMMITFILE=$HOME"/git/projects/aditia_blog/content/pages/commit-logs.md"}


    ########
    # CORE #
    ########

     BLENDER_VERSION="2.76"
    _update_sources()
    {
        #Blender Main & Submodule Update
        cd $HOME/blender-git/blender/
        git stash
	      git fetch -p
        git pull --rebase
        git submodule foreach git pull --rebase origin master

        #Blender extra updates
        # cd $HOME/blender-git/git-addons/animation-nodes && git stash && git fetch -p && git pull
        cd $HOME/blender-git/blender-asset-manager/ && git stash &&  git fetch -p && git pull --rebase
        cd $HOME/blender-git/flamenco/ && git stash && git fetch -p && git pull --rebase
        cd $HOME/blender-git/blender_docs && svn update
    }

    _update_addon_from_git()
    {
        cd $HOME/blender-git/git-addons/ && ./git-pull-all.sh
    }

    _update_env()
    {
        cd $HOME/blender-git/blender/build_files/build_environment/
        ./install_deps.sh  --build-all
    }

    _build_manual()
    {
        cd $HOME/blender-git/blender_docs && make
    }

    _view_manual()
    {
        cd $HOME/blender-git/blender_docs && xdg-open build/html/contents.html
    }

    _update_commit_logs()
    {
      cd $HOME/blender-git/blender
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
        cd $HOME/blender-git/blender
        branchname=$(git symbolic-ref --short -q HEAD)
        echo "# Current Branch : ![alt text][logo] *$branchname*" > $HOME/blender-git/log.md
        echo '[logo]: file:///home/aditia/blender-git/blender_48.png "Logo Blender"' >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BLENDER " >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -30 >> $HOME/blender-git/log.md

        #cd $HOME/blender-git/git-addons/animation-nodes && echo "" >> $HOME/blender-git/log.md
        #echo "" >> $HOME/blender-git/log.md
        #echo "### ANIMATION NODES " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        #echo "" >> $HOME/blender-git/log.md
        #echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        #echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        #git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $HOME/blender-git/blender/release/scripts/addons/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### ADDONS " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $HOME/blender-git/blender/release/scripts/addons_contrib/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### ADDONS CONTRIB" >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $HOME/blender-git/blender-asset-manager/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BAM " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s | *%cr*' -15 >> $HOME/blender-git/log.md

        cd $HOME/blender-git/flamenco/ && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### FLAMENCO " >> $HOME/blender-git/log.md
        #echo "-------------------------------" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "user | hash | comment | time" >> $HOME/blender-git/log.md
        echo "--- | --- | --- | ---" >> $HOME/blender-git/log.md
        git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $HOME/blender-git/log.md

        cd $HOME/blender-git/blender_docs  && echo "" >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "### BLENDER MANUAL " >> $HOME/blender-git/log.md
        echo "" >> $HOME/blender-git/log.md
        echo "rev | user | date | time | comment " >> $HOME/blender-git/log.md
        echo "--- | --- | --- | --- | ---" >> $HOME/blender-git/log.md
        svn log -l15 | ../svn_short_log >> $HOME/blender-git/log.md
    }

    _view_log()
    {
        google-chrome $HOME/blender-git/log.md
    }

    _configure_and_build_sources()
    {
        cd $HOME/blender-git/blender/
        make -j4
        notify-send -t 2000 -i blender "Compiling Blender GIT" "Done :D"
    }

    _check_branch()
    {
        cd $HOME/blender-git/blender/
        git branch
    }

    _gitg()
    {
        cd $HOME/blender-git/blender/ && gitg
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
    echo "   (1) Update Blender & compile"
    echo "   (2) Compile only"
    echo "   (3) Update only"
    echo "   (4) Update addons from git"
    echo "   (5) Update Deps"
    echo "   (6) Check current branch"
    echo "   (7) view log "
    echo "   (8) view in gitg"
    echo "   (9) Exit"
    echo ""
    echo "------------------------------------------------------------"
    echo -n "               Enter your choice (1-4) then press [enter] :"
    read mainmenu
    echo " "
    clear

        if [ "$mainmenu" = 1 ]; then
            _update_sources
            _configure_and_build_sources
            _build_manual
            _update_view_log
            _view_log
            _endkey

        elif [ "$mainmenu" = 2 ]; then
            _configure_and_build_sources
            _build_manual
            _view_log
            _endkey

        elif [ "$mainmenu" = 3 ]; then
            _update_sources
            _update_view_log
            _update_commit_logs
            _view_log
            _endkey

        elif [ "$mainmenu" = 4 ]; then
            _update_addon_from_git
            _endkey

        elif [ "$mainmenu" = 5 ]; then
            _update_env
            _endkey

        elif [ "$mainmenu" = 6 ]; then
            _check_branch
            _endkey

        elif [ "$mainmenu" = 7 ]; then
            _update_view_log
            _view_log
            _endkey

        elif [ "$mainmenu" = 8 ]; then
            _gitg
            _endkey

        elif [ "$mainmenu" = 9 ]; then
            echo "Bye ! "

        else
        echo "the script couldn't understand your choice, try again...";

        fi;
