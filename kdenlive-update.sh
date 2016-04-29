#!/bin/sh
#
#: Title       : kdenlive-update
#: Author      : Aditia A. Pratama < aditia -dot- ap -at- gmail.com >
#: License     : GPL
#  version 0.2

INSTALL_PREFIX=/opt/kdenlive

_update_source()
{
  cd $HOME/kdenlive-src/mlt
  git stash
  git fetch -p
  git pull origin master --rebase

  cd $HOME/kdenlive-src/kdenlive
  git stash
  git fetch -p
  #git pull origin Applications/15.12 --rebase
  git pull origin master --rebase

  cd $HOME/kdenlive-src/movit
  git stash
  git fetch -p
  #git pull origin Applications/15.12 --rebase
  git pull origin master --rebase

  cd $HOME/kdenlive-src/FFmpeg
  git stash
  git fetch -p
  git pull origin master --rebase
}

_compile_ffmpeg()
{
  cd $HOME/kdenlive-src/FFmpeg
  ./configure --prefix=$INSTALL_PREFIX --disable-doc --disable-ffserver --enable-gpl --enable-version3 --enable-shared --disable-static --enable-debug --enable-pthreads --enable-runtime-cpudetect --enable-libtheora --enable-libvorbis --enable-nonfree --enable-libx264
  make
  make install
  echo Success Compiling FFmpeg
}

  _compile_movit()
{
  cd $HOME/kdenlive-src/movit
  ./autogen.sh --prefix=/usr/local --disable-static
  make clean
  make 
  make install
  echo Success Compiling LibMovit

}

_compile_mlt()
{
  cd $HOME/kdenlive-src/mlt
  ./configure --enable-gpl --enable-gpl3 --prefix=$INSTALL_PREFIX \
	  --qt-includedir=/usr/include/qt5 --qt-libdir=/usr/lib64
  make clean
  make
  make install
  echo Success Compiling Latest MLT
}

_compile_kdenlive()
{
  cd $HOME/kdenlive-src/build
  export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib
  export XDG_DATA_DIRS=$INSTALL_PREFIX/share:$XDG_DATA_DIRS:/usr/share
  PKG_CONFIG_PATH=$INSTALL_PREFIX/lib/pkgconfig cmake ../kdenlive -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DCMAKE_BUILD_TYPE="RelWithDebInfo"
  make -j4 install
}

_print_log()
{
  cd $HOME/kdenlive-src/kdenlive
  branchname=$(git symbolic-ref --short -q HEAD)
  echo "# Current Branch : ![alt text][logo] *$branchname*" > $HOME/kdenlive-src/log.md
  echo '[logo]: file:////opt/kdenlive/share/icons/hicolor/48x48/apps/kdenlive.png "Logo Kdenlive"' >> $HOME/kdenlive-src//log.md
  echo "" >> $HOME/kdenlive-src/log.md
  echo "### KDENLIVE " >> $HOME/kdenlive-src/log.md
  echo "" >> $HOME/blender-git/log.md
  echo "user | hash | comment | time" >> $HOME/kdenlive-src/log.md
  echo "--- | --- | --- | ---" >> $HOME/kdenlive-src/log.md
  git log --pretty=format:'%cn | `%h` | %s | *%cr*' -30 >> $HOME/kdenlive-src/log.md
  google-chrome $HOME/kdenlive-src/log.md
}

_update_source
_compile_ffmpeg
_compile_mlt
_compile_kdenlive
_print_log
