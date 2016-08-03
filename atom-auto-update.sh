#!/bin/bash

  _download_from_git()
  {
    wget -c https://github.com/atom/atom/releases/latest -O /tmp/latest
    wget -c $(awk -F '[<>]' '/href=".*atom-amd64.deb/ {match($0,"href=\"(.*.deb)\"",a); print "https://github.com/" a[1]} ' /tmp/latest) -O /tmp/atom-amd64.deb
    sudo dpkg -i /tmp/atom-amd64.deb
  }

  _switch_to_master()
  {
    cd $HOME/git/apps/atom && git fetch -p
    git checkout master
    git pull
    echo "You are now in Master Branch"
  }

  _switch_to_stable()
  {
    cd $HOME/git/apps/atom && git fetch -p
    git checkout stable
    git merge $(git describe --tags `git rev-list --tags --max-count=1`)
    echo "You are now in Stable Branch"
  }

  _update_sources()
  {
    cd $HOME/git/apps/atom && git stash && git fetch -p
    branchname=$(git symbolic-ref --short -q HEAD)
    if [ $branchname = "stable" ]; then
      git merge $(git describe --tags `git rev-list --tags --max-count=1`)
    else
      git pull
    fi
  }
  
  _update_beta()
  {
    cd $HOME/git/apps/atom-beta 
    git reset && git stash  
    git fetch -p
    git pull
  }
  
  _update_all_packages()
  {
    apm update
    apm rebuild
  }
  
  _print_log()
  {
    cd $HOME/git/apps/atom
    branchname=$(git symbolic-ref --short -q HEAD)
    echo "# Atom Development Log" > $HOME/git/apps/atom/log.md
    echo "" >> $HOME/git/apps/atom/log.md
    echo "### ATOM ![masterlogo](file:////home/aditia/git/apps/atom/resources/app-icons/dev/png/24.png) *$branchname*" >> $HOME/git/apps/atom/log.md
    echo "---" >> $HOME/git/apps/atom/log.md
    echo "" >> $HOME/git/apps/atom/log.md
    echo "user | hash | comment | time" >> $HOME/git/apps/atom/log.md
    echo "--- | --- | --- | ---" >> $HOME/git/apps/atom/log.md
    git log --pretty=format:'%cn | `%h` | %s |  on %cr' -15 >> $HOME/git/apps/atom/log.md
    echo "" >> $HOME/git/apps/atom/log.md
    echo "" >> $HOME/git/apps/atom/log.md
    echo "---" >> $HOME/git/apps/atom/log.md
    cd $HOME/git/apps/atom-beta
    branchname=$(git symbolic-ref --short -q HEAD)
    echo "" >> $HOME/git/apps/atom/log.md
    echo "### ATOM-BETA ![betalogo](file:////home/aditia/git/apps/atom-beta/resources/app-icons/beta/png/24.png) *$branchname*" >> $HOME/git/apps/atom/log.md
    echo "---" >> $HOME/git/apps/atom/log.md
    echo "" >> $HOME/git/apps/atom/log.md
    echo "user | hash | comment | time" >> $HOME/git/apps/atom/log.md
    echo "--- | --- | --- | ---" >> $HOME/git/apps/atom/log.md
    git log --pretty=format:'%cn | `%h` | %s |  on %cr' -15 >> $HOME/git/apps/atom/log.md
  }
  
  _clean()
  {
    cd $HOME/git/apps/atom
    script/clean
    cd $HOME/git/apps/atom-beta
    script/clean
    sleep 3s
    echo 'Success Clean Build'
  }
  
  _build()
  {
    cd $HOME/git/apps/atom
    script/build
  }
  
  _build_beta()
  {
    cd $HOME/git/apps/atom-beta
    script/build
  }
  
  _install()
  {
    cd $HOME/git/apps/atom
    sudo script/grunt install
  }
  
  _install_beta()
  {
    cd $HOME/git/apps/atom-beta
    sudo script/grunt install
  }
  
  _make_deb()
  {
    cd $HOME/git/apps/atom
    sudo script/grunt mkdeb
  }

  _install_deb()
  {
    cd /tmp/atom-build
    sudo dpkg -i atom*.deb
  }

  _view_log()
  {
    cd $HOME/git/apps/atom && google-chrome log.md
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
echo "   (1) Update Source and Clean Build Only"
echo "   (2) Update Source and View Logs Only"
echo "   (3) Compile, Install and View Logs Only"
echo "   (4) Make DEB and Install"
echo "   (5) Download from git"
echo "   (6) Exit"
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
    _clean
    _view_log
    _endkey

  elif [ "$mainmenu" = 2 ]; then
    _update_sources
    _update_beta
    _print_log
    _view_log
    _endkey

  elif [ "$mainmenu" = 3 ]; then
    _build
    _build_beta
    _install
    _install_beta
    _view_log
    _endkey

  elif [ "$mainmenu" = 4 ]; then
    _make_deb
    _install_deb
    _endkey

  elif [ "$mainmenu" = 5 ]; then
    _download_from_git
    _endkey

  elif [ "$mainmenu" = 6 ]; then
    _endkey

  else
    echo "the script couldn't understand your choice, try again...";
  fi;
 
