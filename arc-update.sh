#!/bin/sh
# Git Repo Location
: ${ARCTHEME="/home/aditia/git/xfce4/arc-theme"}
: ${ADAPTA="/home/aditia/git/xfce4/Adapta"}
: ${ARCGREY="/home/aditia/git/xfce4/arc-grey-theme"}
: ${ARCICON="/home/aditia/git/xfce4/arc-icon-theme"}
: ${MOKAICON="/home/aditia/git/xfce4/moka-icon-theme"}
: ${PAPERICON="/home/aditia/git/xfce4/paper-icon-theme"}
: ${NUMIXICON="/home/aditia/git/xfce4/numix-icon-theme"}
: ${NUMIXCIRCLEICON="/home/aditia/git/xfce4/numix-icon-theme-circle"}
: ${PAPIRUSICON="/home/aditia/git/xfce4/papirus-icon-theme-gtk"}

# Default to git pull with FF merge in quiet mode
GIT_COMMAND="git pull --quiet"

# User messages
GU_ERROR_FETCH_FAIL="Unable to fetch the remote repository."
GU_ERROR_UPDATE_FAIL="Unable to update the local repository."
GU_ERROR_NO_GIT="This directory has not been initialized with Git."
GU_INFO_REPOS_EQUAL="The local repository is current. No update is needed."
GU_SUCCESS_REPORT="Update complete."

_update_arc()
{
	cd $ARCTHEME
	echo "#ARC THEME " > $ARCTHEME/logs.md
  echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
  git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $ARCGREY
  echo "" >> $ARCTHEME/logs.md
	echo "#ARC GREY THEME " >> $ARCTHEME/logs.md
  echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $ADAPTA
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
  echo "" >> $ARCTHEME/logs.md
	echo "" >> $ARCTHEME/logs.md
	echo "# ARC ICON" >> $ARCTHEME/logs.md
	echo "" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
  git log --pretty=format:'%cn | `%h` | %s |  *%cr*' -15 >> $ARCTHEME/logs.md

	cd $MOKAICON
	echo "" >> $ARCTHEME/logs.md
	echo "# MOKA ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md

	cd $PAPERICON
	echo "" >> $ARCTHEME/logs.md
	echo "# PAPER ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md

	cd $PAPIRUSICON
	echo "" >> $ARCTHEME/logs.md
	echo "# PAPIRUS ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md

	cd $NUMIXICON
	echo "" >> $ARCTHEME/logs.md
	echo "# NUMIX ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md

	cd $NUMIXCIRCLEICON
	echo "" >> $ARCTHEME/logs.md
	echo "# NUMIX CIRCLE ICON" >> $ARCTHEME/logs.md
  echo "user | hash | comment | time"  >> $ARCTHEME/logs.md
  echo "--- | --- | --- | ---" >> $ARCTHEME/logs.md
	git log --pretty=format:"%cn | committed %h | %s |  on %cr" -15 >> $ARCTHEME/logs.md
}
_install_arc()
{
	cd $ARCTHEME
	git remote update >&-
	if (( $? )); then
      echo $GU_ERROR_FETCH_FAIL >&2
      exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Arc Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			sudo rm -rf /usr/share/themes/{Arc,Arc-Dark,Arc-Darker}
			rm -rf ~/.local/share/themes/{Arc,Arc-Dark,Arc-Darker}
			rm -rf ~/.themes/{Arc,Arc-Dark,Arc-Darker}
			./autogen.sh --prefix=/usr
			sudo make install
      if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
        exit 1
      else
        echo $GU_SUCCESS_REPORT
      fi
		fi
	fi

	cd $ARCGREY
	git remote update >&-
	if (( $? )); then
      echo $GU_ERROR_FETCH_FAIL >&2
      exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Arc Grey Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			sudo rm -rf /usr/share/themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
			rm -rf ~/.local/share/themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
			rm -rf ~/.themes/{Arc-Grey,Arc-Dark-Grey,Arc-Darker-Grey}
			./autogen.sh --prefix=/usr
			sudo make install
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
        exit 1
      else
        echo $GU_SUCCESS_REPORT
      fi
		fi
	fi

	cd $ARCICON
	git remote update >&-
	if (( $? )); then
      echo $GU_ERROR_FETCH_FAIL >&2
      exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Arc Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			./autogen.sh --prefix=/usr
			sudo make install
			sudo gtk-update-icon-cache /usr/share/icons/Arc
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
        exit 1
      else
        echo $GU_SUCCESS_REPORT
      fi
		fi
	fi

	cd $PAPERICON
	git remote update >&-
	if (( $? )); then
      echo $GU_ERROR_FETCH_FAIL >&2
      exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Paper Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			./autogen.sh
			make
			sudo make install
			sudo gtk-update-icon-cache /usr/share/icons/Paper
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
        exit 1
      else
        echo $GU_SUCCESS_REPORT
      fi
		fi
	fi

	# cd $ADAPTA
	# git remote update >&-
	# if (( $? )); then
  #   echo $GU_ERROR_FETCH_FAIL >&2
  #   exit 1
  # else
	# 	LOCAL=$(git rev-parse --verify HEAD)
	# 	REMOTE=$(git rev-parse --verify FETCH_HEAD)
	# 	if [ $LOCAL = $REMOTE ]; then
	# 		echo "Now updating Adapta Theme ..."
	# 		echo $GU_INFO_REPOS_EQUAL
	# 	else
	# 		git reset && git stash && git clean -fdx
	# 		$GIT_COMMAND
	# 		sudo rm -rf /usr/share/themes/{Adapta-Nokto}
	# 		rm -rf ~/.local/share/themes/{Adapta-Nokto}
	# 		rm -rf ~/.themes/{Adapta-Nokto}
	# 		./autogen.sh --enable-parallel --enable-plank --enable-chrome
	# 		make
	# 		sudo make install
	# 		if (( $? )); then
	# 			echo $GU_ERROR_UPDATE_FAIL >&2
  #       exit 1
  #     else
  #       echo $GU_SUCCESS_REPORT
  #     fi
	# 	fi
	# fi

	cd $MOKAICON
	git remote update >&-
	if (( $? )); then
    echo $GU_ERROR_FETCH_FAIL >&2
    exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Moka Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			./autogen.sh
			make && sudo make install
			sudo gtk-update-icon-cache /usr/share/icons/Moka
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
				exit 1
			else
				echo $GU_SUCCESS_REPORT
			fi
		fi
	fi

	cd $PAPIRUSICON
	git remote update >&-
	if (( $? )); then
    echo $GU_ERROR_FETCH_FAIL >&2
    exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Papirus Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			sudo gtk-update-icon-cache /usr/share/icons/Papirus-GTK/
			sudo gtk-update-icon-cache /usr/share/icons/Papirus-Dark-GTK/
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
				exit 1
			else
				echo $GU_SUCCESS_REPORT
			fi
		fi
	fi

	cd $NUMIXICON
	git remote update >&-
	if (( $? )); then
    echo $GU_ERROR_FETCH_FAIL >&2
    exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Numix Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			sudo gtk-update-icon-cache /usr/share/icons/Numix
			sudo gtk-update-icon-cache /usr/share/icons/Numix-Light/
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
				exit 1
			else
				echo $GU_SUCCESS_REPORT
			fi
		fi
	fi

	cd $NUMIXCIRCLEICON
	git remote update >&-
	if (( $? )); then
    echo $GU_ERROR_FETCH_FAIL >&2
    exit 1
  else
		LOCAL=$(git rev-parse --verify HEAD)
		REMOTE=$(git rev-parse --verify FETCH_HEAD)
		if [ $LOCAL = $REMOTE ]; then
			echo "Now updating Numix-Circle Icon Theme ..."
			echo $GU_INFO_REPOS_EQUAL
		else
			git reset && git stash && git clean -fdx
			$GIT_COMMAND
			sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle/
			sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle-Light/
			if (( $? )); then
				echo $GU_ERROR_UPDATE_FAIL >&2
				exit 1
			else
				echo $GU_SUCCESS_REPORT
			fi
		fi
	fi
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
_install_arc
_update_arc
_update_arc_moka_icon
_view_log
_endkey
