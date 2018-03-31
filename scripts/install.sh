#/bin/sh
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

BASEDIR=$(dirname "$0")

# Prompt for installing apts before going ahead with the dotfiles
read -p "Install programs from apt? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
      $BASEDIR/apts.sh
esac
echo

# Install dotfiles
dotfiles=".zshrc .Xresources .gitconfig"
for dotfile in $dotfiles; do
  printf "Installing %s .... \n" $dotfile
  #ln -svf 2> /dev/null
done
