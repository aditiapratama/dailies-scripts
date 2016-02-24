#!/bin/bash
# This script will install the structure project folder

_create()
{
  mkdir -p pro/{01_edit,02_lib/{animlib,chars/tex,fonts,props/tex,envs/tex,scripts,background/src},03_shots};
  mkdir -p pre/{breakdown,character,references,tutorial,storyboard/{_assets,_templates}}
  mkdir -p render/{animatic,frames,playblast};
  mkdir movies;
  mkdir -p sounds/{music,soundfx,vo};
  mkdir -p extras/documents;
  echo "Project Folder Creation Success"
}

_clean()
{
  mbtotal=$(find . \( -name "*.blend1" -o -name "*.blend2" \) -printf '%k\n' | awk '{total=total+$1}END{mbtotal = total / 1024 * 1024 ; print mbtotal}')
  echo "start cleaning ..."
  #exec >/dev/null 2>&1
  find . \( -name "*.blend1" -o -name "*.blend2" \) | gawk 'BEGIN{a=1}{printf "rm -rf %s\n", $0, a++}' | bash
  sleep 3s
  echo "$mbtotal" KB has been cleaned
}

# TODO 01 add feature to clean project, ie remove blend1, blend2 - DONE
# TODO 02 add feature to compress project
# TODO 03 check current project/directory empty or not, if empty then create project

case "$1" in
  create)
    _create
    ;;
  clean)
    _clean
    ;;
    *)
      echo "/usr/bin/project {create | clean}"
      exit 1
esac
exit 0
