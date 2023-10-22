#!/bin/bash

# The Script creates a preferences.sh file and stores user's preferences in it.
# Installs Arch based on the preferences.

set -a
this_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
install_scripts_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts/install
set +a

source $install_scripts_dir/functions.sh  # including basic functions
bash $install_scripts_dir/setup-1.sh

mkdir -p /mnt/tmp
cp -r ohmyarch /mnt/tmp/
arch-chroot /mnt tmp/ohmyarch/scripts/install/setup-2.sh

source /mnt/tmp/ohmyarch/scripts/install/preferences.sh # for including username
arch-chroot /mnt /usr/bin/runuser -u $username -- /mnt/tmp/ohmyarch/scripts/install/user_setup.sh

clrscr
echo -e "Setup Completed! will Reboot in 10s"
echo -e "Make sure to remove the installation media!"
getch
sleep 10s
reboot now
