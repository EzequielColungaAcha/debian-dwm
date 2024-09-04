#!/usr/bin/env bash

# Update and install essential packages
sudo apt update && sudo apt install nala -y
clear

# Fetch and install packages using nala
sudo nala fetch
sudo nala install xorg git wget curl build-essential libx11-dev libxft-dev libxinerama-dev zip -y
echo "Base X installed"

# Setup repository keys and sources
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null

# Chrome repository setup
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

# Microsoft repository setup
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Docker repository setup
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update repositories and install software
sudo nala update
sudo nala install google-chrome-stable code apt-transport-https ca-certificates gnupg docker-ce docker-ce-cli containerd.io docker-buildx-plugin python3 python3-pip imagemagick procps psmisc xdotool xsel feh libxfixes-dev picom network-manager-gnome tree trash-cli bash-completion fzf ripgrep bat eza zoxide plocate btop fd-find tldr arandr thunar pulseaudio pavucontrol ntfs-3g libnotify-bin dunst pasystray glow libglib2.0-dev -y
ln -s $(which fdfind) ~/.local/bin/fd
sudo usermod -aG docker "$USER"
sudo chmod 666 /var/run/docker.sock
echo "Chrome, VsCode and Docker installed"

# Install Python packages
sudo pip3 install pywal --break-system-packages

# Setup user environment
mkdir -p ~/.local/src ~/.local/bin ~/.local/wallpapers ~/.local/share/fonts
cp ~/debian-dwm/src/* ~/.local/src/
cp ~/debian-dwm/scripts/* ~/.local/bin/
cp ~/debian-dwm/wallpapers/* ~/.local/wallpapers
WALLPAPER=$(find ~/.local/wallpapers -type f | shuf -n 1)
wal -i "$WALLPAPER"
cp ~/debian-dwm/fonts/* ~/.local/share/fonts/

# Replace .bashrc and .xinitrc
rm -f ~/.bashrc
cp ~/debian-dwm/.bashrc ~/
rm -f ~/.xinitrc
cp ~/debian-dwm/.xinitrc ~/.xinitrc

# Build and install dwm, st, slstatus, dmenu, clipmenu, and clipnotify
for app in dwm st slstatus; do
    cd ~/.local/src/$app
    make
    ln -sf ~/.local/src/$app/$app ~/.local/bin/
    echo "$app ready"
done

for app in dmenu clipmenu clipnotify; do
    cd ~/.local/src/$app
    sudo make clean install
    echo "$app ready"
done

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz

# Install lazydocker and volta
curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
curl -fsSL https://get.volta.sh | bash
echo "Don't forget to install node and yarn with 'volta install node yarn'"

# Configure network interfaces
sudo mv /etc/network/interfaces /etc/network/interfaces.bak
sudo cp ~/debian-dwm/interfaces /etc/network/

# Cleanup
rm -rf ~/debian-dwm

echo "Setup complete"
