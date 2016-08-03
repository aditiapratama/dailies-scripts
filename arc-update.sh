#!/bin/sh
: ${ARCTHEME="/home/aditia/git/xfce4/arc-theme"}
: ${ADAPTA="/home/aditia/git/xfce4/Adapta"}
: ${ARCGREY="/home/aditia/git/xfce4/arc-grey-theme"}
: ${ARCICON="/home/aditia/git/xfce4/arc-icon-theme"}
: ${MOKAICON="/home/aditia/git/xfce4/moka-icon-theme"}
: ${PAPERICON="/home/aditia/git/xfce4/paper-icon-theme"}

_update_arc()
{
	cd $ARCTHEME
	git reset
	git stash
	git clean -fdx
	git fetch
	git pull
	echo "#ARC THEME " > $ARCTHEME/logs.md
  echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
  git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $ARCGREY
	git reset
	git stash
  git clean -fdx
	git fetch
	git pull
  echo "" >> $ARCTHEME/logs.md
	echo "#ARC GREY THEME " >> $ARCTHEME/logs.md
  echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $ADAPTA
	git reset
	git stash
  git clean -fdx
	git fetch
	git pull
  echo "" >> $ARCTHEME/logs.md
	echo "#ADAPTA THEME " >> $ARCTHEME/logs.md
  echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md
}
_update_arc_moka_icon()
{
	cd $ARCICON
  git reset
	git stash
  git clean -fdx
	git fetch
	git pull
  echo "" >> $ARCTHEME/logs.md
	echo "" >> $ARCTHEME/logs.md
	echo "# ARC ICON" >> $ARCTHEME/logs.md
	echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
  git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $MOKAICON
	git reset
	git stash
  git clean -fdx
	git fetch
	git pull
	echo "" >> $ARCTHEME/logs.md
	echo "# MOKA ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md

	cd $PAPERICON
	git reset
	git stash
  git clean -fdx
	git fetch
	git pull
	echo "" >> $ARCTHEME/logs.md
	echo "# PAPER ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md
}
_install_arc()
{
	LOCAL=$(git rev-parse @)
	REMOTE=$(git rev-parse @{u})
	BASE=$(git merge-base @ @{u})

	clear
	cd $ARCTHEME
	if [ $LOCAL = $REMOTE ]; then
		echo "Arc Theme is up-to-date"
	else
		sudo rm -rf /usr/share/themes/{Arc,Arc-Dark,Arc-Darker}
		rm -rf ~/.local/share/themes/{Arc,Arc-Dark,Arc-Darker}
		rm -rf ~/.themes/{Arc,Arc-Dark,Arc-Darker}
		./autogen.sh --prefix=/usr
		sudo make install
	fi

	cd $ARCGREY
	if [ $LOCAL = $REMOTE ]; then
		echo "Arc Grey Theme is up-to-date"
	else
		sudo rm -rf /usr/share/themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
		rm -rf ~/.local/share/themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
		rm -rf ~/.themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
		./autogen.sh --prefix=/usr
		sudo make install
	fi

	cd $ARCICON
	if [ $LOCAL = $REMOTE ]; then
		echo "Arc Icon is up-to-date"
	else
		./autogen.sh --prefix=/usr
		sudo make install
	fi

	cd $PAPERICON
	if [ $LOCAL = $REMOTE ]; then
		echo "Paper Icon is up-to-date"
	else
		./autogen.sh
		make
		sudo make install
	fi

	cd $ADAPTA
	if [ $LOCAL = $REMOTE ]; then
		echo "Adapta Theme is up-to-date"
	else
		sudo rm -rf /usr/share/themes/{Adapta-Nokto}
		rm -rf ~/.local/share/themes/{Adapta-Nokto}
		rm -rf ~/.themes/{Adapta-Nokto}
		./autogen.sh --enable-parallel --enable-plank --enable-chrome
		make
		sudo make install
	fi

	cd $MOKAICON
	if [ $LOCAL = $REMOTE ]; then
		echo "Moka Icon is up-to-date"
	else
		./autogen.sh
		make && sudo make install
	fi
}
_gtk_icon_update()
{
	sudo gtk-update-icon-cache /usr/share/icons/Arc
	sudo gtk-update-icon-cache /usr/share/icons/Moka
	sudo gtk-update-icon-cache /usr/share/icons/Paper

}
_view_log()
{
  google-chrome $ARCTHEME/logs.md
}
_endkey()
{
	echo -n "Press [enter] to exit"
  read END
}
### run de skript
_update_arc
_update_arc_moka_icon
_install_arc
_gtk_icon_update
_view_log
_endkey
