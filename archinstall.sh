#!/usr/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Install essential packages
sudo pacman -S --noconfirm base-devel xorg-server git wget curl zip

echo "Base X installed"

# Add Google Chrome repository
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo pacman-key --add -
sudo pacman-key --lsign-key FEC3 6D6A D63F 9D8E 6D73 F5E2 55F2 9D3A 8C5D 78F7
sudo sh -c 'echo "[arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/pacman.conf'
echo "Chrome key added"

# Add VS Code repository
sudo pacman-key --recv-keys EB3E 94AD BE12 5E59 3878 A25D 0FF4 9999 A2D9 0C12
sudo sh -c 'echo "[arch=amd64] https://packages.microsoft.com/repos/vscode stable main" >> /etc/pacman.conf'
echo "VsCode key added"

# Add Docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo pacman-key --add -
echo "deb [arch=$(uname -m)] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/pacman.d/docker.list
echo "Docker key added"

# Update system again (recommended after adding new repositories)
sudo pacman -Syu --noconfirm

# Install remaining packages
sudo pacman -S --noconfirm google-chrome-stable code docker docker-compose python python-pip imagemagick procps-ng psmisc xdotool xsel feh libxfixes picom networkmanager tree zoxide trash-cli bash-completion fzf

# Enable Docker daemon at startup and start it
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Add user to Docker group
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock

echo "Chrome, VsCode, Docker, and other utilities installed"

# Install pywal using pip3
sudo pip install pywal --upgrade

# Move files and configure environment
mkdir -p ~/.local/src
mv ~/debian-dwm/src/* ~/.local/src/
mkdir -p ~/.local/bin
mv ~/debian-dwm/scripts/* ~/.local/bin/
mkdir -p ~/.local/wallpapers
mv ~/debian-dwm/wallpapers/* ~/.local/wallpapers
WALLPAPER=$(find ~/.local/wallpapers -type f | shuf -n 1)
wal -i $WALLPAPER
mkdir -p ~/.local/share/fonts
mv ~/debian-dwm/fonts/* ~/.local/share/fonts/
rm ~/.bashrc
mv ~/debian-dwm/.bashrc ~/

# Compile and install dwm, st, slstatus, dmenu, clipmenu, clipnotify
cd ~/.local/src/dwm
make
ln -sf ~/.local/src/dwm/dwm ~/.local/bin/
echo "dwm ready"

cd ~/.local/src/st
make
ln -sf ~/.local/src/st/st ~/.local/bin/
echo "st ready"

cd ~/.local/src/slstatus
make
ln -sf ~/.local/src/slstatus/slstatus ~/.local/bin/
echo "slstatus ready"

cd ~/.local/src/dmenu
sudo make clean install
echo "dmenu ready"

cd ~/.local/src/clipmenu
sudo make clean install

cd ~/.local/src/clipnotify
sudo make clean install

cd ~
rm ~/.xinitrc
mv ~/debian-dwm/.xinitrc ~/.xinitrc

# Install Volta (for managing Node.js and Yarn versions)
curl https://get.volta.sh | bash

echo "Don't forget to install node and yarn with 'volta install node yarn'"

# Clean up
rm -rf ~/debian-dwm
