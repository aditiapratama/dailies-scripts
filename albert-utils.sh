#!/bin/bash

# --- Restarting Albert
_restart()
{
	exec >/dev/null 2>&1
	killall albert && albert &
}

_restart
