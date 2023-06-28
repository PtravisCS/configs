#!/bin/bash 

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install apache2
sudo apt-get install apache2-dev
sudo apt-get install aptitude
sudo apt-get install build-essential
sudo apt-get install clisp
sudo apt-get install composer
sudo apt-get install curl
sudo apt-get install docker
sudo apt-get install ffmpeg
sudo apt-get install gimp
sudo apt-get install git
sudo apt-get install gnome-tweaks
sudo apt-get install highlight
sudo apt-get install imagemagick
sudo apt-get install imagemagick-6.q16
sudo apt-get install keepassx

# Required for Android Studio
sudo apt-get install android-sdk lib32z1 libapr1 libapr1-dev libaprutil1-dev libbz2-1.0:i386 libc6:i386 libncurses5:i386 libstdc++6:i386

sudo apt-get install microsoft-edge-stable
sudo apt-get install ncal
sudo apt-get install net-tools
sudo apt-get install nodejs
sudo apt-get install npm
sudo apt-get install openjdk-8-jre
sudo apt-get install openssh-server
sudo apt-get install perl-doc
sudo apt-get install php
sudo apt-get install php8.1-curl
sudo apt-get install php8.1-fpm
sudo apt-get install php8.1-gd
sudo apt-get install php8.1-mbstring
sudo apt-get install php8.1-mysql
sudo apt-get install php8.1-opcache
sudo apt-get install php8.1-pgsql
sudo apt-get install php8.1-soap
sudo apt-get install php8.1-sqlite3
sudo apt-get install php8.1-xml
sudo apt-get install php8.1-zip
sudo apt-get install php-codesniffer
sudo apt-get install php-redis
sudo apt-get install php-ssh2
sudo apt-get install postgresql
sudo apt-get install powershell
sudo apt-get install python3-pip
sudo apt-get install python3-venv
sudo apt-get install qt5-qmake
sudo apt-get install qtbase5-dev
sudo apt-get install qtbase5-doc-html
sudo apt-get install qtbase5-examples
sudo apt-get install qtcreator
sudo apt-get install r-base
sudo apt-get install redis-server
sudo apt-get install rename
sudo apt-get install screen
sudo apt-get install smbclient
sudo apt-get install solaar
sudo apt-get install spell
sudo apt-get install tmux
sudo apt-get install tree
sudo apt-get install vim
sudo apt-get install vlc
sudo apt-get install wl-clipboard

# Install Neovim
cd ~/
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xvzf nvim-linux64.tar.gz -C nvim-linux64
cd nvim-linux64
rsync -a ./bin/ /usr/bin/
rsync -a ./lib/ /usr/lib/
rsync -a ./share/ /usr/share/
rsync -a ./man/ /usr/local/man

sudo apt-get autoremove
sudo apt-get install --fix-missing

cd ~/
rm -rf ./nvim-linux64.tar.gz
rm -rf ./nvim-linux64

# Install NerdFont
cd ~/
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf
sudo mv ./UbuntuMonoNerdFontMono-Regular.ttf ~/.local/share/fonts/
sudo chmod 644 ~/.local/share/fonts/UbuntuMonoNerdFontMono-Regular.ttf
