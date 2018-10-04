#!/usr/bin/env bash

# Profile file - runs on login

export PATH="$PATH:$HOME/.scripts"
export EDITOR="vim"
export TERMINAL="urxvt"
export BROWSER="firefox"
export TRUEBROWSER="firefox"

[ -f ~/.scripts/shortcuts.sh ] && ~/.scripts/shortcuts.sh

[ -f ~/.bashrc ] && source ~/.bashrc

# Start graphical server if i3 not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x i3 || exec startx
fi

# Prompt the user for time 
.scripts/time track
