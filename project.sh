#!/bin/bash
# This script will install the boilerplate project folder
# How to install
# ==============
# - just download this script and put in /usr/local/bin
# - you can rename it to `project`
# - assign permission to execute `chmod +x`
# - done

LB='\e[1;34m'
LG='\e[1;32m'
LR='\e[1;31m'
NC='\e[0m' # No Color

_init()
{
  #FILE=""
  dir=$(pwd)
  dirname=$(basename "$dir")

  # init
  # look for empty dir
  if [ "$(ls -A $dir)" ]; then
      echo -e "${LB}$dirname ${NC}has some content, please check before init. "
  else
      echo -e "Now creating project boilerplate on ${LB}$dirname"
      mkdir -p pro/{01_edit,02_lib/{animlib,chars/tex,fonts,props/tex,envs/tex,scripts,background/src},03_shots};
      mkdir -p pre/{breakdown,character,references,tutorial,storyboard/{_assets,_templates}}
      mkdir -p render/{animatic,frames,playblast};
      mkdir movies;
      mkdir -p sounds/{music,soundfx,vo};
      mkdir -p extras/documents;
      sleep 3s
      tree -dC .
      echo -e "${NC}Project ${LB}$dirname ${NC}init success"
  fi
}

#_zip()
#{
  # zip -qr - [folder] | pv -bep -s $(du -bs [folder] | awk '{print $1}') > [file.zip]
#}

_clean()
{
  mbtotal=$(find . \( -name "*.blend1" -o -name "*.blend2" \) -printf '%k\n' | awk '{total=total+$1}END{mbtotal = total / 1024 * 1024 ; print mbtotal}')
  echo -e "start cleaning ${LR}$mbtotal KB"
  #exec >/dev/null 2>&1
  find . \( -name "*.blend1" -o -name "*.blend2" \) | gawk 'BEGIN{a=1}{printf "rm -rf %s\n", $0, a++}' | bash
  sleep 3s
  echo -e "${LG}$mbtotal KB ${NC}has been cleaned"
}

_afclean()
{
  year=$(date +'%Y')
  mbtotal=$(find . \( -name "*."$year"*.blend" \) -printf '%k\n' | awk '{total=total+$1}END{mbtotal = total / 1024 * 1024 ; print mbtotal}')
  echo -e "start cleaning ${LR}$mbtotal KB"
  #exec >/dev/null 2>&1
  find . \( -name "*."$year"*.blend" \) | gawk 'BEGIN{a=1}{printf "rm -rf %s\n", $0, a++}' | bash
  sleep 3s
  echo -e "${LG}$mbtotal KB ${NC}has been cleaned"
}

# TODO 01 feature to clean project and afanasy blend, ie remove blend1, blend2 - DONE
# TODO 02 check current project/directory empty or not, if empty then create project - Done
# TODO 03 add feature to compress project - ONGOING
# TODO 04 interface using python fltk or qt4 !!!

case "$1" in
  init)
    _init
    ;;
  clean)
    _clean
    ;;
  afclean)
    _afclean
    ;;
    *)
      echo "/usr/bin/project {init | clean | afclean}"
      exit 1
esac
exit 0
