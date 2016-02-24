#!/bin/bash

_update_source()
{
  cd $HOME/mpv-build
  ./update
}

_install_dep()
{
  cd $HOME/mpv-build
  rm -f mpv-build-deps_*_*.deb
  mk-build-deps -s sudo -i
}

_build()
{
  cd $HOME/mpv-build
  dpkg-buildpackage -uc -us -b -j4
}

_install_mpv()
{
  cd $HOME/mpv-build
  sudo dpkg -i ../mpv_*.deb
  mv $HOME/mpv_*.deb $HOME/Apps/deb_files/
  mv $HOME/mpv_*.changes $HOME/Apps/deb_files/
}

# run de skript
_update_source
_install_dep
_build
_install_mpv
