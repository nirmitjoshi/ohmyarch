#!/bin/bash

# Setting up Arch the way I love it...

source /ohmyarch/scripts/install/functions.sh
source /ohmyarch/scripts/install/preferences.sh

# Setting up dotfiles

clrscr
echo -e "Setting up Hyprland..."
sudo pacman -S --needed --noconfirm hyprland hyprpaper kitty git stow

sudo rm -r /home/$username/.config/hypr # had errors in stow due to pre-created config files
sudo rm -r /home/$username/.config/kitty # ,,

clrscr
git clone https://github.com/nirmitjoshi/ohmyarch /home/$username/ohmyarch/
cd /home/$username/ohmyarch/
stow .
cd ~
echo -e "Done"
getch

# Setting up yay

clrscr
echo -e "Installing yay..."
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
cd ~
sudo rm -r yay-git
echo -e "Done"
sleep 1s

# Setting up shell(zsh)

clrscr
echo -e "Installing and Configuring zsh..."
sudo pacman -S --noconfirm --needed zsh fd fzf
yay -S --noconfirm starship autojump ttf-jetbrains-mono-nerd
sudo chsh -s /bin/zsh root
chsh -s /bin/zsh $username
mkdir /home/$username/.config/zsh-plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$username/.config/zsh-plugins/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/$username/.config/zsh-plugins/zsh-autosuggestions/
echo -e "\nDone"
sleep 2s

# Setting up Notifications

clrscr
echo -e "Setting up Notifications..."
sudo pacman -S --noconfirm --needed dunst cronie acpi
yay -S --noconfirm brillo
sudo cp /home/$username/scripts/custom_scripts/power.rules /etc/udev/rules.d/
command="/home/$username/scripts/custom_scripts/batterynotify"
job="*/3 * * * * $command"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
echo -e "Done"
sleep 1s

# Setting up Filemanager

clrscr
echo -e "Setting up Ranger(cli file manager)..."
sudo pacman -S --noconfirm --needed ranger python-pillow atool mupdf-tool
echo -e "Done"
sleep 1s

# Setting up Applications manager

clrscr
echo -e "Setting up Rofi(applications manager)..."
sudo pacman -S --noconfirm --needed rofi
sudo cp /home/$username/scripts/rofi/rofi-audio.desktop /usr/share/applications/
sudo cp /home/$username/scripts/rofi/rofi-wifi-menu.desktop /usr/share/applications/
echo -e "Done"
sleep 1s

# Installing additional pkgs

clrscr
echo -e "Installing additonal pkgs..."
sudo pacman -S --noconfirm --needed firefox neovim obsidian syncthing discord vlc polkit-kde-agent qt5-wayland qt6-wayland
sudo systemctl --user enable syncthing.service
yay -S --noconfirm youtube--music-bin github-desktop-bin
echo -e "Done"
sleep 1s

# Personal Comments

clrscr
echo -e "Things left to setup:\n"
echo -e "1) Obsidian Setup:\n\ti. Git clone the notes\n\tii. Setup Syncthing localhost:8384"
echo -e "2) Setup Firefox:\n\ti.userChrome.css and user.js\n\tii.Extension:\n\t\ta. Tab Center Reborn CSS\n\t\tb. Tampermonkey Script"
echo -e "3) Neovim\n"
getch

