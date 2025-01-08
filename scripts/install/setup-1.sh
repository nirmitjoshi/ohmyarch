#!/bin/bash

# GETTING USER PREFERENCES
# ---------------------------------------------------------------------------------------------------------------
source $install_scripts_dir/functions.sh

clrscr

# creating preferences file:
PREF_FILE=$install_scripts_dir/preferences.sh
if [ ! -f $PREF_FILE ]; then
  touch -f $PREF_FILE
fi

bg_check
get_hostname
clrscr
get_password_root
clrscr
get_username
get_password_user
clrscr
get_timezone
getch
get_disk
clrscr
echo -e "All Done! Sit back and relax!"
echo -e "Starting with installation in 3s"
sleep 3s

# BASE INSTALLATION
# ---------------------------------------------------------------------------------------------------------------
source PREF_FILE

# Setting mirrors and enabling parallel downloads
clrscr
timedatectl set-ntp true
pacman -Sy --noconfirm archlinux-keyring
pacman -S --noconfirm --needed pacman-contrib
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

mirror=$(curl -4 ifconfig.co/country-iso)
reflector -a 48 -c $mirror -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# Setting Disk
clrscr
echo -e "Setting up Disk for Installation..."
sleep 2s
umount -A --recursive /mnt
sgdisk -Z $disk
sgdisk -a 2048 -o $disk
sgdisk -n 1::+512M --typecode=1:ef00 --change-name=1:'EFIBOOT' $disk
sgdisk -n 2::+${root_partn_size_gb}G --typecode=2:8300 --change-name=2:'ROOT' $disk
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'HOME' $disk
partprobe $disk

mkfs.vfat -F32 ${disk}1
mkfs.ext4 -F ${disk}2
mkfs.ext4 -F ${disk}3

mount -t ext4 ${disk}2 /mnt

mkdir -p /mnt/boot/efi
mkdir -p /mnt/home

mount -t vfat ${disk}1 /mnt/boot
mount -t ext4 ${disk}3 /mnt/home

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted, Cannot Continue! System will be rebooted"
    getch
    echo "Rebooting in 3 Seconds ..." && sleep 1
    echo "Rebooting in 2 Seconds ..." && sleep 1
    echo "Rebooting in 1 Second ..." && sleep 1
    reboot now
fi
echo -e "\n\nDisk Setup Completed!"
getch

# Installing base system
clrscr
echo -e "Installing Base system and Kernel..."
pacstrap /mnt base base-devel linux linux-headers linux-firmware --noconfirm --needed
echo -e "\nBase System and Kernel Installed!"
sleep 3s
clrscr
echo -e "Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "Generated /etc/fstab !"
getch
sleep 3s

