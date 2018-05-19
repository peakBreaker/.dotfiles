#!/bin/sh
echo -n '\e[32m'
echo "                   _    ____                 _             "
echo "                  | |  |  _ \               | |            "
echo "  _ __   ___  __ _| | _| |_) |_ __ ___  __ _| | _____ _ __ "
echo " | '_ \ / _ \/ _\` | |/ /  _ <| '__/ _ \\/ _\` | |/ / _ \ '__|"
echo " | |_) |  __/ (_| |   <| |_) | | |  __/ (_| |   <  __/ |   "
echo " | .__/ \___|\__,_|_|\_\____/|_|  \___|\__,_|_|\_\___|_|   "
echo " | |                                                       "
echo " |_|                                                       "
echo ""
echo -n '\e[37m'
echo "--- Welcome to my dotfiles repo for autoinstalling devenv ---"

## Some configs for the script exec
dotfiles=".spacemacs .zshrc .Xresources .gitconfig .vimrc .vim .urxvt"

## Get basedir and run the script
BASEDIR="$( cd "$(dirname "$0")/.." ; pwd -P )"
. $BASEDIR/scripts/scriptutils.sh
INFO "BASEDIR IS :: " $BASEDIR

# Prompt for installing apts before going ahead with the dotfiles
read -p "Install programs from apt? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
      $BASEDIR/scripts/apts.sh
esac
echo

read -p "Create symlinks to .dotfiles? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
	INFO "Creating symlinks for all config files"

	# Install dotfiles
	for dotfile in $dotfiles; do
	  INFO "Installing $dotfile ...."
	  ln -svf "$BASEDIR/files/$dotfile" "$HOME/${dotfile##*/}" 2>&1
	  SUCCESS "Successfully installed dotfile :: $dotfile ! \n"
	done
esac
echo

# Install the .config
read -p "Install .config files? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
  INFO "Installing .config directory"
  ERROR "NOT YET IMPLEMENTED"
esac
echo
