#!/usr/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update system
sudo pacman -Syu --noconfirm || { echo "Failed to update system"; exit 1; }

# Install essential packages
sudo pacman -S --noconfirm base-devel xorg-server git wget curl zip || { echo "Failed to install essential packages"; exit 1; }

echo "Base X installed"

# Add Google Chrome repository
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo pacman-key --add - || { echo "Failed to add Google Chrome key"; exit 1; }
sudo pacman-key --lsign-key FEC3 6D6A D63F 9D8E 6D73 F5E2 55F2 9D3A 8C5D 78F7 || { echo "Failed to sign Google Chrome key"; exit 1; }
sudo sh -c 'echo "[arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/pacman.conf' || { echo "Failed to add Google Chrome repository"; exit 1; }
echo "Chrome key added"

# Add VS Code repository
sudo pacman-key --recv-keys EB3E 94AD BE12 5E59 3878 A25D 0FF4 9999 A2D9 0C12 || { echo "Failed to add VS Code key"; exit 1; }
sudo sh -c 'echo "[arch=amd64] https://packages.microsoft.com/repos/vscode stable main" >> /etc/pacman.conf' || { echo "Failed to add VS Code repository"; exit 1; }
echo "VsCode key added"

# Add Docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo pacman-key --add - || { echo "Failed to add Docker key"; exit 1; }
echo "deb [arch=$(uname -m)] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/pacman.d/docker.list || { echo "Failed to add Docker repository"; exit 1; }
echo "Docker key added"

# Update system again (recommended after adding new repositories)
sudo pacman -Syu --noconfirm || { echo "Failed to update system after adding repositories"; exit 1; }

# Install remaining packages
sudo pacman -S --noconfirm google-chrome-stable code docker docker-compose python python-pip imagemagick procps-ng psmisc xdotool xsel feh libxfixes picom networkmanager tree zoxide trash-cli bash-completion fzf || { echo "Failed to install remaining packages"; exit 1; }

# Enable Docker daemon at startup and start it
sudo systemctl enable docker.service || { echo "Failed to enable Docker service"; exit 1; }
sudo systemctl start docker.service || { echo "Failed to start Docker service"; exit 1; }

echo "Chrome, VsCode, Docker, and other utilities installed"

# Add user to Docker group
sudo usermod -aG docker ${USER} || { echo "Failed to add user to Docker group"; exit 1; }
sudo chmod 666 /var/run/docker.sock || { echo "Failed to chmod Docker socket"; exit 1; }

# Install pywal using pip3
sudo pip install pywal --upgrade || { echo "Failed to install pywal"; exit 1; }

# Move files and configure environment
mkdir -p ~/.local/src || { echo "Failed to create directory ~/.local/src"; exit 1; }
mv ~/debian-dwm/src/* ~/.local/src/ || { echo "Failed to move source files to ~/.local/src"; exit 1; }
mkdir -p ~/.local/bin || { echo "Failed to create directory ~/.local/bin"; exit 1; }
mv ~/debian-dwm/scripts/* ~/.local/bin/ || { echo "Failed to move scripts to ~/.local/bin"; exit 1; }
mkdir -p ~/.local/wallpapers || { echo "Failed to create directory ~/.local/wallpapers"; exit 1; }
mv ~/debian-dwm/wallpapers/* ~/.local/wallpapers || { echo "Failed to move wallpapers to ~/.local/wallpapers"; exit 1; }
WALLPAPER=$(find ~/.local/wallpapers -type f | shuf -n 1) || { echo "Failed to select random wallpaper"; exit 1; }
wal -i $WALLPAPER || { echo "Failed to apply wallpaper using wal"; exit 1; }
mkdir -p ~/.local/share/fonts || { echo "Failed to create directory ~/.local/share/fonts"; exit 1; }
mv ~/debian-dwm/fonts/* ~/.local/share/fonts/ || { echo "Failed to move fonts to ~/.local/share/fonts"; exit 1; }
rm ~/.bashrc || { echo "Failed to remove ~/.bashrc"; exit 1; }
mv ~/debian-dwm/.bashrc ~/ || { echo "Failed to move .bashrc"; exit 1; }

# Compile and install dwm, st, slstatus, dmenu, clipmenu, clipnotify
cd ~/.local/src/dwm || { echo "Failed to change directory to ~/.local/src/dwm"; exit 1; }
make || { echo "Failed to compile dwm"; exit 1; }
ln -sf ~/.local/src/dwm/dwm ~/.local/bin/ || { echo "Failed to create symlink for dwm"; exit 1; }
echo "dwm ready"

cd ~/.local/src/st || { echo "Failed to change directory to ~/.local/src/st"; exit 1; }
make || { echo "Failed to compile st"; exit 1; }
ln -sf ~/.local/src/st/st ~/.local/bin/ || { echo "Failed to create symlink for st"; exit 1; }
echo "st ready"

cd ~/.local/src/slstatus || { echo "Failed to change directory to ~/.local/src/slstatus"; exit 1; }
make || { echo "Failed to compile slstatus"; exit 1; }
ln -sf ~/.local/src/slstatus/slstatus ~/.local/bin/ || { echo "Failed to create symlink for slstatus"; exit 1; }
echo "slstatus ready"

cd ~/.local/src/dmenu || { echo "Failed to change directory to ~/.local/src/dmenu"; exit 1; }
sudo make clean install || { echo "Failed to install dmenu"; exit 1; }
echo "dmenu ready"

cd ~/.local/src/clipmenu || { echo "Failed to change directory to ~/.local/src/clipmenu"; exit 1; }
sudo make clean install || { echo "Failed to install clipmenu"; exit 1; }

cd ~/.local/src/clipnotify || { echo "Failed to change directory to ~/.local/src/clipnotify"; exit 1; }
sudo make clean install || { echo "Failed to install clipnotify"; exit 1; }

cd ~
rm ~/.xinitrc || { echo "Failed to remove ~/.xinitrc"; exit 1; }
mv ~/debian-dwm/.xinitrc ~/.xinitrc || { echo "Failed to move .xinitrc"; exit 1; }

# Install Volta (for managing Node.js and Yarn versions)
curl https://get.volta.sh | bash || { echo "Failed to install Volta"; exit 1; }

echo "Don't forget to install node and yarn with 'volta install node yarn'"
