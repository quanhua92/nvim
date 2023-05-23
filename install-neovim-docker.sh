#!/bin/bash
apt update && apt install -y unzip python3-venv
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node

cd /tmp/
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
rm -rf /squashfs-root
mv squashfs-root /
rm /usr/bin/vim
rm /usr/bin/nvim
ln -s /squashfs-root/AppRun /usr/bin/vim
ln -s /squashfs-root/AppRun /usr/bin/nvim
