#!/usr/bin/env bash

# Profile file - runs on login

# Adds `~/.scripts` and all subdirectories to $PATH
export PATH="$(du $HOME/.scripts/ | cut -f2 | tr '\n' ':')$PATH"
# Adds the apps dir to PATH
export PATH=$PATH:$HOME/apps/
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"
export TRUEBROWSER="firefox"

[ -f ~/.scripts/shortcuts.sh ] && ~/.scripts/shortcuts.sh

[ -f ~/.bashrc ] && source ~/.bashrc

# Start graphical server if i3 not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
    pgrep -x i3 || exec startx
fi

# Prompt the user for time 
.scripts/time track QUIET OTHER CPU_START
# For the keys
export GPG_TTY=$(tty)
