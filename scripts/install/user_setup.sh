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

mkdir -p /home/$username/scripts/
mkdir -p /home/$username/wallpaper/
mkdir -p /home/$username/.config/

cd /home/$username/ohmyarch/
stow --target=/home/$username/.config .config
stow --target=/home/$username/scripts scripts
stow --target=/home/$username/wallpaper wallpaper
cp .zshrc /home/$username/

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

# Setting up zram
yay -S --noconfirm zramswap
sudo sed -i 's/^ZRAM_SIZE_PERCENT=.*/ZRAM_SIZE_PERCENT="300"/' /etc/zramswap.conf
sudo systemctl enable zramswap

# Setting up Notifications

clrscr
echo -e "Setting up Notifications..."
sudo pacman -S --noconfirm --needed dunst cronie acpi
yay -S --noconfirm brillo
command="/home/$username/scripts/custom_scripts/batterynotify"
job="*/3 * * * * $command"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
sudo systemctl enable cronie

INPUT_FILE="/home/$username/scripts/custom_scripts/power.rules"
OUTPUT_FILE="/etc/udev/rules.d/power.rules"
awk -v temp="$username" '{gsub(/\$username/, temp)} 1' "$INPUT_FILE" | sudo tee "$OUTPUT_FILE" > /dev/null

echo -e "Done"
sleep 1s

# Setting up Filemanager

clrscr
echo -e "Setting up Ranger(cli file manager)..."
yay -S --noconfirm --needed ranger python-pillow atool mupdf-tool python-pdftotext
echo -e "Done"
sleep 1s

# Setting up Applications manager

clrscr
echo -e "Setting up Rofi(wayland fork)..."
yay -S --noconfirm --needed rofi-lbonn-wayland-git
sudo cp /home/$username/scripts/rofi/rofi-audio.desktop /usr/share/applications/
sudo cp /home/$username/scripts/rofi/rofi-wifi-menu.desktop /usr/share/applications/
echo -e "Done"
sleep 1s

# Setting up MAL-Sync discord rpc

mkdir -p /home/$username/scripts/custom_scripts/discord-rpc
cd /home/$username/scripts/custom_scripts/discord-rpc
curl -LJO "https://github.com/lolamtisch/Discord-RPC-Extension/releases/latest/download/linux.zip"
unzip linux.zip
sudo rm -r linux.zip
sudo mv server_linux_debug anime_mal_sync
cd ~

# Installing additional pkgs

clrscr
echo -e "Installing additonal pkgs..."
sudo pacman -S --noconfirm --needed firefox neovim obsidian syncthing npm discord grim slurp vlc ripgrep polkit-kde-agent kdeconnect wl-clipboard github-cli qt5-wayland qt6-wayland
systemctl --user enable syncthing.service
yay -S --noconfirm github-desktop-bin lazygit
echo -e "Done"
sleep 1s

# Personal Comments

clrscr
echo -e "Things left to setup:\n"
echo -e "1) Obsidian Setup:\n\ti. Git clone the notes\n\tii. Setup Syncthing localhost:8384"
echo -e "2) Setup Firefox Stylesheets:\n\ti. Tab Center Reborn CSS\n\tii. Tampermonkey Script"
echo -e "3) Login Github-cli"
getch

