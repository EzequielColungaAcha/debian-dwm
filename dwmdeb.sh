#!/usr/bin/bash

thisFolder=$(dirname "$(realpath "$0")")

sudo apt update
sudo apt install nala -y
clear
sudo nala fetch
sudo nala install xorg git wget curl build-essential libx11-dev libxft-dev libxinerama-dev libxcb-res0-dev zip -y
echo "Base X installed"
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
echo "Chrome key added"
wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo "VsCode key added"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Docker key added"
sudo nala update
sudo nala install google-chrome-stable code apt-transport-https ca-certificates gnupg docker-ce docker-ce-cli containerd.io docker-buildx-plugin python3 python3-pip imagemagick procps psmisc xdotool xsel feh libxfixes-dev picom network-manager-gnome tree trash-cli bash-completion fzf ripgrep bat eza zoxide plocate btop fd-find tldr arandr thunar pulseaudio pavucontrol ntfs-3g libnotify-bin dunst pasystray glow libglib2.0-dev pulsemixer -y
ln -s $(which fdfind) ~/.local/bin/fd
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
echo "Chrome, VsCode and Docker installed"
sudo pip3 install pywal --break-system-packages
mkdir -p ~/.local/bin
ln -sf $thisFolder/scripts/* ~/.local/bin/
ln -sf $thisFolder/wallpapers ~/.local/
WALLPAPER=$(find ~/.local/wallpapers -type f | shuf -n 1)
wal -i $WALLPAPER
mkdir -p ~/.local/share/fonts
ln -sf $thisFolder/fonts/* ~/.local/share/fonts/
rm ~/.bashrc
ln -sf $thisFolder/.bashrc ~/
ln -sf $thisFolder/.bash_aliases ~/
ln -sf $thisFolder/.profile ~/
ln -sf $thisFolder/.Xresources ~/
ln -sf $thisFolder/.xinitrc ~/
cd $thisFolder/src/dwm
make
ln -sf $thisFolder/src/dwm/dwm ~/.local/bin/
echo "dwm ready"
cd $thisFolder/src/st
make
ln -sf $thisFolder/src/st/st ~/.local/bin/
echo "st ready"
cd $thisFolder/src/slstatus
make
ln -sf $thisFolder/src/slstatus/slstatus ~/.local/bin/
echo "slstatus ready"
cd $thisFolder/src/dmenu
sudo make clean install
echo "dmenu ready"
cd $thisFolder/src/clipmenu
sudo make clean install
cd $thisFolder/src/clipnotify
sudo make clean install
cd ~/
rm ~/.xinitrc
ln -sf $thisFolder/.xinitrc ~/.xinitrc
cd $thisFolder/src/
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
curl https://get.volta.sh | bash
echo "Don't forget to install node and yarn with 'volta install node yarn'"
cd ~
sudo mv /etc/network/interfaces /etc/network/interfaces.bak
sudo ln -sf $thisFolder/interfaces /etc/network/