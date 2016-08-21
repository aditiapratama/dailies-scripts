#!/bin/bash

CURDIR=$(pwd)
NOW=$(date)

# Default to git pull with FF merge in quiet mode
GIT_COMMAND="git pull --quiet"

# User messages
GU_ERROR_FETCH_FAIL="Unable to fetch the remote repository."
GU_ERROR_UPDATE_FAIL="Unable to update the local repository."
GU_ERROR_NO_GIT="This directory has not been initialized with Git."
GU_INFO_REPOS_EQUAL="The local repository is current. No update is needed."
GU_SUCCESS_REPORT="Update complete."

echo "Debug Logs => $NOW" > logs.md
echo =================== >> logs.md

for f in $CURDIR/*;
  do
	clear;
  if [[ -d $f ]]; then
    echo Now Updating "${f##*/}";
	  cd "$f";
    if [ -d ".git" ]; then
      git remote update >&-
      if (( $? )); then
        echo $GU_ERROR_FETCH_FAIL >&2
        exit 1
      else
        LOCAL_SHA=$(git rev-parse --verify HEAD)
        REMOTE_SHA=$(git rev-parse --verify FETCH_HEAD)
        if [ $LOCAL_SHA = $REMOTE_SHA ]; then
          echo $GU_INFO_REPOS_EQUAL
          echo "${f##*/} is up-to-date " >> ../logs.md
        else
          git reset && git stash && git clean -fdx
          $GIT_COMMAND
          if (( $? )); then
    				echo $GU_ERROR_UPDATE_FAIL >&2
            exit 1
          else
            echo $GU_SUCCESS_REPORT
            echo "^ ${f##*/} has been updated to latest version" >> ../logs.md
          fi
        fi
      fi
    else
      echo $GU_ERROR_NO_GIT >&2
      echo "${f##*/} is not a git repo " >> ../logs.md
    fi
  fi;
	sleep 1s && echo finish updating "${f##*/}";
  done;
