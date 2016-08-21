#!/bin/bash
: ${ATOM="/home/aditia/git/apps/atom"}
: ${ATOMBETA="/home/aditia/git/apps/atom-beta"}

# Default to git pull with FF merge in quiet mode
GIT_COMMAND="git pull --quiet"

# User messages
GU_ERROR_FETCH_FAIL="Unable to fetch the remote repository."
GU_ERROR_UPDATE_FAIL="Unable to update the local repository."
GU_ERROR_NO_GIT="This directory has not been initialized with Git."
GU_INFO_REPOS_EQUAL="The local repository is current. No update is needed."
GU_SUCCESS_REPORT="Update complete."

  _download_from_git()
  {
    wget -c https://github.com/atom/atom/releases/latest -O /tmp/latest
    wget -c $(awk -F '[<>]' '/href=".*atom-amd64.deb/ {match($0,"href=\"(.*.deb)\"",a); print "https://github.com/" a[1]} ' /tmp/latest) -O /tmp/atom-amd64.deb
    sudo dpkg -i /tmp/atom-amd64.deb
  }

  _switch_to_master()
  {
    cd $ATOM && git fetch -p
    git checkout master
    git pull
    echo "You are now in Master Branch"
  }

  _switch_to_stable()
  {
    cd $ATOM && git fetch -p
    git checkout stable
    git merge $(git describe --tags `git rev-list --tags --max-count=1`)
    echo "You are now in Stable Branch"
  }

  _update_sources()
  {
    cd $ATOM
    git remote update >&-
  	if (( $? )); then
        echo $GU_ERROR_FETCH_FAIL >&2
        exit 1
    else
      BRANCH=$(git symbolic-ref --short -q HEAD)
      LOCAL_SHA=$(git rev-parse --verify HEAD)
      REMOTE_SHA=$(git rev-parse --verify FETCH_HEAD)
      if [ $LOCAL_SHA = $REMOTE_SHA ]; then
        echo $GU_INFO_REPOS_EQUAL
        echo "Atom $BRANCH is up-to-date "
      else
        $GIT_COMMAND
        echo "Now building atom $BRANCH"
        script/build
        echo "Now installing atom $BRANCH"
        sudo script/grunt install
        if (( $? )); then
          echo $GU_ERROR_UPDATE_FAIL >&2
          exit 1
        else
          echo $GU_SUCCESS_REPORT
        fi
      fi
    fi
    # if [ $BRANCH = "stable" ]; then
    #   git merge $(git describe --tags `git rev-list --tags --max-count=1`)
    # else
    #   git pull
    # fi
  }

  _update_beta()
  {
    cd $ATOMBETA
    git remote update >&-
  	if (( $? )); then
        echo $GU_ERROR_FETCH_FAIL >&2
        exit 1
    else
      BRANCH=$(git symbolic-ref --short -q HEAD)
      LOCAL_SHA=$(git rev-parse --verify HEAD)
      REMOTE_SHA=$(git rev-parse --verify FETCH_HEAD)
      if [ $LOCAL_SHA = $REMOTE_SHA ]; then
        echo $GU_INFO_REPOS_EQUAL
        echo "Atom $BRANCH is up-to-date "
      else
        $GIT_COMMAND
        echo "Now building atom $BRANCH"
        script/build
        echo "Now installing atom $BRANCH"
        sudo script/grunt install
        if (( $? )); then
          echo $GU_ERROR_UPDATE_FAIL >&2
          exit 1
        else
          echo $GU_SUCCESS_REPORT
        fi
      fi
    fi
  }

  _update_all_packages()
  {
    apm update
    apm rebuild
  }

  _print_log()
  {
    cd $ATOM
    BRANCH=$(git symbolic-ref --short -q HEAD)
    echo "# Atom Development Log" > $ATOM/log.md
    echo "" >> $ATOM/log.md
    echo "### ATOM ![masterlogo](file:////home/aditia/git/apps/atom/resources/app-icons/dev/png/24.png) *$BRANCH*" >> $ATOM/log.md
    echo "---" >> $ATOM/log.md
    echo "" >> $ATOM/log.md
    echo "user | hash | comment | time" >> $ATOM/log.md
    echo "--- | --- | --- | ---" >> $ATOM/log.md
    git log --pretty=format:'%cn | `%h` | %s |  on %cr' -15 >> $ATOM/log.md
    echo "" >> $ATOM/log.md
    echo "" >> $ATOM/log.md
    echo "---" >> $ATOM/log.md
    cd $ATOMBETA
    BRANCH=$(git symbolic-ref --short -q HEAD)
    echo "" >> $ATOM/log.md
    echo "### ATOM-BETA ![betalogo](file:////home/aditia/git/apps/atom-beta/resources/app-icons/beta/png/24.png) *$BRANCH*" >> $ATOM/log.md
    echo "---" >> $ATOM/log.md
    echo "" >> $ATOM/log.md
    echo "user | hash | comment | time" >> $ATOM/log.md
    echo "--- | --- | --- | ---" >> $ATOM/log.md
    git log --pretty=format:'%cn | `%h` | %s |  on %cr' -15 >> $ATOM/log.md
  }

  _clean()
  {
    cd $ATOM
    script/clean
    cd $ATOMBETA
    script/clean
    sleep 3s
    echo 'Success Clean Build'
  }

  _build()
  {
    cd $ATOM
    script/build
  }

  _build_beta()
  {
    cd $ATOMBETA
    script/build
  }

  _install()
  {
    cd $ATOM
    sudo script/grunt install
  }

  _install_beta()
  {
    cd $ATOMBETA
    sudo script/grunt install
  }

  _make_deb()
  {
    cd $ATOM
    sudo script/grunt mkdeb
  }

  _install_deb()
  {
    cd /tmp/atom-build
    sudo dpkg -i atom*.deb
  }

  _view_log()
  {
    cd $ATOM && google-chrome log.md
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
echo "ATOM-UPDATE"
echo "------------------------------------------------------------"
echo ""
echo "   (1) Update Source, Build and Install Only"
echo "   (2) Clean, Compile, Install and View Logs Only"
echo "   (3) Make DEB and Install"
echo "   (4) Download from git"
echo "   (5) Exit"
echo ""
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-6) then press [enter] :"
read mainmenu
echo " "
clear

  if [ "$mainmenu" = 1 ]; then
    _update_sources
    _update_beta
    _print_log
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _build
    _build_beta
    _install
    _install_beta
    _view_log
    _endkey

  elif [ "$mainmenu" = 3 ]; then
    _make_deb
    _install_deb
    _endkey

  elif [ "$mainmenu" = 4 ]; then
    _download_from_git
    _endkey

  elif [ "$mainmenu" = 5 ]; then
    _endkey

  else
    echo "the script couldn't understand your choice, try again...";
  fi;
