#!/usr/bin/bash
sudo apt update
sudo apt install nala -y
clear
sudo nala fetch
sudo nala install xorg git wget curl build-essential libx11-dev libxft-dev libxinerama-dev zip -y
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
mkdir -p ~/.local/src
cp ~/debian-dwm/src/* ~/.local/src/
mkdir -p ~/.local/bin
cp ~/debian-dwm/scripts/* ~/.local/bin/
mkdir -p ~/.local/wallpapers
cp ~/debian-dwm/wallpapers/* ~/.local/wallpapers
WALLPAPER=$(find ~/.local/wallpapers -type f | shuf -n 1)
wal -i $WALLPAPER
mkdir -p ~/.local/share/fonts
cp ~/debian-dwm/fonts/* ~/.local/share/fonts/
rm ~/.bashrc
cp ~/debian-dwm/.bashrc ~/
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
cd ~/
rm ~/.xinitrc
cp ~/debian-dwm/.xinitrc ~/.xinitrc
cd ~/.local/src/
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
sudo cp ~/debian-dwm/interfaces /etc/network/
rm ~/debian-dwm