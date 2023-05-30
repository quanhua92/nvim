#!/bin/bash
apt update && apt install -y unzip python3-venv ripgrep tmux pgformatter locales
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

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
mv lazygit /usr/bin
rm /usr/bin/lg
ln -s /usr/bin/lazygit /usr/bin/lg

cp ~/.config/nvim/.tmux.conf ~/.tmux.conf
echo "alias tmux='tmux -u'" >> ~/.bashrc
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
locale-gen en_US.UTF-8
tmux kill-server
