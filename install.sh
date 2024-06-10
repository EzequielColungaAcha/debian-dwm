#!/usr/bin/bash
sudo apt update
sudo apt install nala -y
clear
sudo nala fetch
sudo nala install xorg git wget curl build-essential libx11-dev libxft-dev libxinerama-dev zip -y
echo "Base X installed"
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
sudo nala install google-chrome-stable code apt-transport-https ca-certificates gnupg docker-ce docker-ce-cli containerd.io docker-buildx-plugin python3 python3-pip imagemagick procps psmisc xdotool xsel feh libxfixes-dev -y
ln -s $(which fdfind) ~/.local/bin/fd
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
echo "Chrome, VsCode and Docker installed"
mv ~/debian-dwm/src ~/.local/
mkdir -p ~/.local/bin
cd ~/.local/src/dwm
make
ln -sf ~/.local/src/dwm/dwm ~/.local/bin/
echo "dwm ready"
cd ~/.local/src/st
make
ln -sf ~/.local/src/st/st ~/.local/bin/
echo "st ready"
cd ~/.local/src/dmenu
sudo make clean install
echo "dmenu ready"
cd ~/.local/src/clipmenu
sudo make clean install
cd ~/.local/src/clipnotify
sudo make clean install
cd ~/
rm ~/.xinitrc
mv ~/debian-dwm/.xinitrc ~/.xinitrc
mv ~/debian-dwm/scripts/* ~/.local/bin
curl https://get.volta.sh | bash
echo "Don't forget to install node and yarn with 'volta install node yarn'"
startx &
st -e volta install node yarn