#!/bin/bash 

sudo apt-get update
sudo apt-get upgrade

progs=('apache2' 
  'apache2-dev' 
  'aptitude' 
  'build-essential' 
  'cargo' 
	'catimg'
	'clisp'
	'composer'
	'cpanminus'
	'curl'
	'docker'
	'dos2unix'
	'evolution'
	'evolution-ews'
	'fd-find'
	'feh'
	'ffmpeg'
	'flake8'
	'gldal-bin'
	'gforth'
  'gimp'
  'git'
  'gnome-tweaks'
  'highlight'
  'imagemagick'
  'imagemagick-6.q16'
  'libperl-critic-perl'
  'lua5.4'
  'inkscape'
  'keepassx'
  'microsoft-edge-stable'
  'ncal'
  'net-tools'
  'nodejs'
  'npm'
  'openjdk-8-jre'
  'openssh-server'
  'perl-doc'
  'php'
	'php8.1-curl'
	'php8.1-fpm'
	'php8.1-gd'
	'php8.1-mbstring'
	'php8.1-mysql'
	'php8.1-opcache'
	'php8.1-pgsql'
	'php8.1-soap'
	'php8.1-sqlite3'
	'php8.1-xml'
	'php8.1-zip'
	'php-bcmath'
	'php-codesniffer'
	'php-redis'
	'php-ssh2'
	'postgresql'
	'powershell'
	'python3-pip'
	'python3-venv'
	'qt5-qmake'
	'qtbase5-dev'
	'qtbase5-doc-html'
	'qtbase5-examples'
	'qtcreator'
	'r-base'
	'redis-server'
	'rename'
	'ripgrep'
	'screen'
	'shellcheck'
	'sleuthkit'
	'smbclient'
	'solaar'
	'spell'
	'tmux'
	'tree'
	'vim'
	'vlc'
	'wajig'
	'wl-clipboard'
)

for t in "${progs[@]}"; do
  printf 'Installing %s\n' "$t"
  sudo apt-get -qq install "$t"
done

# Required for Android Studio
printf 'Installing android studio and dependancies\n'
sudo apt-get -qq install android-sdk lib32z1 libapr1 libapr1-dev libaprutil1-dev libbz2-1.0:i386 libc6:i386 libncurses5:i386 libstdc++6:i386

printf "Do you wish to install NeoVim? "
read -r yon

if [[ "$yon" == 'y' ]]; then
  # Install Neovim
  cd ~/ || return
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
  tar -xvzf nvim-linux64.tar.gz
  cd nvim-linux64 || (printf 'Unable to CD into nvim-linux64' && exit)
  sudo rsync -a ./bin/ /usr/bin/
  sudo rsync -a ./lib/ /usr/lib/
  sudo rsync -a ./share/ /usr/share/
  sudo rsync -a ./man/ /usr/local/man
fi

sudo apt-get autoremove
sudo apt-get install --fix-missing

cd ~/ || return
rm -rf ./nvim-linux64.tar.gz
rm -rf ./nvim-linux64

# Install NerdFont
cd ~/ || return
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf
sudo mv ./UbuntuMonoNerdFontMono-Regular.ttf ~/.local/share/fonts/
sudo chmod 644 ~/.local/share/fonts/UbuntuMonoNerdFontMono-Regular.ttf

# Install nvr
pip3 install neovim-remote
pip3 install sqlfluff

# Install nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# shellcheck source=/home/travisp/.bashrc
source ~/.bashrc
nvm install node
nvm use node

# Install Perl dependencies
sudo cpan install 'LWP::Simple'
sudo cpan install 'Mojo::DOM'
sudo cpan install 'Term::ANSIColor'
sudo cpan install 'IO::Interactive'
