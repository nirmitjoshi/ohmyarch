#!/bin/bash

# Setting up Arch the way I love it...
source /ohmyarch/scripts/install/functions.sh
source /ohmyarch/scripts/install/preferences.sh

# Setting up dotfiles
clrscr
echo -e "Setting up Hyprland..."
sudo pacman -S --needed --noconfirm hyprland hyprpaper hyprlock kitty git stow

sudo rm -r /home/$username/.config/hypr  # had errors in stow due to pre-created config files
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

# Setting up zram 200% of ram size
total_ram=$(grep MemTotal /proc/meminfo | awk '{print $2 * 1024 * 2}')
echo "zram" | sudo tee /etc/modules-load.d/zram.conf

cat <<EOF | sudo tee /etc/udev/rules.d/99-zram.rules
ACTION=="add", KERNEL=="zram0", ATTR{comp_algorithm}="lz4", ATTR{disksize}="$total_ram", RUN="/usr/bin/mkswap -U clear /dev/%k", TAG+="systemd"
EOF

if ! grep -q "/dev/zram0" /etc/fstab; then
	echo "/dev/zram0 none swap defaults,discard,pri=100 0 0" | sudo tee -a /etc/fstab
fi

# Setting up Notifications
clrscr
echo -e "Setting up Notifications..."
sudo pacman -S --noconfirm --needed libnotify dunst cronie acpi
yay -S --noconfirm brillo
command="/home/$username/scripts/custom_scripts/batterynotify"
job="*/3 * * * * $command"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
sudo systemctl enable cronie

INPUT_FILE="/home/$username/scripts/custom_scripts/power.rules"
OUTPUT_FILE="/etc/udev/rules.d/power.rules"
awk -v temp="$username" '{gsub(/\$username/, temp)} 1' "$INPUT_FILE" | sudo tee "$OUTPUT_FILE" >/dev/null

echo -e "Done"
sleep 1s

# Setting up Filemanager
clrscr
echo -e "Setting up Ranger(cli file manager) && Nautilus..."
yay -S --noconfirm --needed ranger python-pillow atool mupdf-tool python-pdftotext nautilus
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

# Installing additional pkgs
clrscr
echo -e "Installing additonal pkgs..."
sudo pacman -S --noconfirm --needed neovim obsidian syncthing npm grim slurp vlc ripgrep rustup tree polkit-kde-agent kdeconnect wl-clipboard github-cli qt5-wayland qt6-wayland unzip openssh docker pavucontrol man-db
rustup default stable
systemctl --user enable syncthing.service
sudo systemctl start docker.service
sudo systemctl enable docker.service
yay -S --noconfirm zen-browser-bin vesktop hyprsome-git
echo -e "Done"
sleep 1s

# Personal Comments
clrscr
echo -e "Things left to setup:\n"
echo -e "1) Obsidian Setup:\n\ti. Git clone the notes\n\tii. Setup Syncthing localhost:8384"
getch
