#!/bin/bash
: ${ATOM="/home/aditia/git/apps/atom"}
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
    wget -c $(awk -F '[<>]' '/href=".*atom-amd64.rpm/ {match($0,"href=\"(.*.rpm)\"",a); print "https://github.com/" a[1]} ' /tmp/latest) -O /tmp/atom-amd64.rpm
    sudo dpkg -ivh --force /tmp/atom-amd64.rpm
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
        echo "Now building & installing Atom $BRANCH"
        script/build --install /opt/atom
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
  }

  _clean()
  {
    cd $ATOM
    sudo chmod -R 777 $ATOM
    script/clean
    git clean -fdx
    git stash
    sleep 3s
    echo 'Success Clean Build'
  }

  _build()
  {
    cd $ATOM
    #sudo chmod -R 775 $ATOM
    script/build
  }

  _install()
  {
    cd $ATOM
    script/build --install /opt/atom
  }

  _install_rpm()
  {
    cd $ATOM
    script/build --create-rpm-package
    sudo dnf install ./out/atom.x86_64.rpm
  }

  _view_log()
  {
    cd $ATOM
    markdown2 -x tables log.md > log.html
    xdg-open log.html
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
echo "   (1) Update & Compile Atom"
echo "   (2) Compile Atom"
#echo "   (3) Make DEB and Install"
echo "   (3) Download from git"
echo "   (4) Exit"
echo ""
echo "------------------------------------------------------------"
echo -n "               Enter your choice (1-6) then press [enter] :"
read mainmenu
echo " "
clear

  if [ "$mainmenu" = 1 ]; then
    _update_sources
    _print_log
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _install
    _print_log
    _view_log
    _endkey

  #elif [ "$mainmenu" = 3 ]; then
    #_make_deb
    #_install_deb
    #_endkey

  elif [ "$mainmenu" = 3 ]; then
    _download_from_git
    _endkey

  elif [ "$mainmenu" = 4 ]; then
    _endkey

  else
    echo "the script couldn't understand your choice, try again...";
  fi;
