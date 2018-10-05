#!/usr/bin/env bash
export SUDO_ASKPASS="$HOME/.scripts/dpass"

xrdb -merge ~/.Xresources
exec i3
