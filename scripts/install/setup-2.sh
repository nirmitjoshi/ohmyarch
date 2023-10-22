#!/bin/bash

# setup-2.sh ---> run it with arch-chroot /mnt

source /tmp/ohmyarch/scripts/install/functions.sh
source /tmp/ohmyarch/scripts/install/preferences.sh

# Timezone and Locale Setup
clrscr
echo -e "\e[1mWorking inside the ROOT System!\e[0m]"
echo -e "\nSetting up Time Zone to ${timezone}..."
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc
echo -e "Done"
sleep 1s

echo -e "\nSetting up Locale..."
echo "en_IN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_IN,UTF-8" > /etc/locale.conf
echo -e "Done"
sleep 1s

# Network Setup
clrscr
echo -e "Setting up Network..."
pacman -S --noconfirm --needed networkmanager reflector
systemctl enable --now NetworkManager
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
echo -e "Done"
sleep 1s

# Audio Setup
clrscr
echo -e "Setting up Audio..."
pacman -S --noconfirm --needed bluez bluex-utils pulseaudio pulseaudio-bluetooth pamixer
systemctl enable --now bluetooth
echo -e "Done"
sleep 1s

# Installing Drivers and Microcode
clrscr
echo -e "Installing Drivers and Microcode..."

proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    echo "Installing Intel microcode"
    pacman -S --noconfirm --needed intel-ucode
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    echo "Installing AMD microcode"
    pacman -S --noconfirm --needed amd-ucode
fi

gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
    pacman -S --noconfirm --needed nvidia
	nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
    pacman -S --noconfirm --needed xf86-video-amdgpu
elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
    pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
    pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
fi

echo -e "Done"
sleep 1s

# Setting Hosts and Users
clrscr
echo -e "Setting up Hosts and Users..."
echo $hostname > /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   ${hostname}.localdomain $hostname" >> /etc/hosts

echo "root:$root_pass" | chpasswd

useradd -m -G wheel -s /bin/bash $username
echo "$username:$user_pass" | chpasswd
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers #giving sudo access
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers #passwordless sudo access
echo -e "Done"
sleep 1s

# Installing GRUB
clrscr
echo -e "Setting up GRUB..."
pacman -S --needed -noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/mnt/boot --bootloader-id=GRUB
grub-mkconfig -o /mnt/boot/grub/grub.cfg
echo -e "Done"

clrscr
echo -e "Basic Arch Setup Completed!"
echo -e "\nProceeding with User Setup..."
getch

