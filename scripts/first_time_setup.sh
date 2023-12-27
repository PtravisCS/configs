#!/bin/bash 

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
  'libpar-packer-perl'
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
  'glow'
)

printf 'Do you want to add the glow markdown reader repo to the sources list?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
      echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
      break
      ;;
    'n'|'N') break ;;
  esac
done

printf 'Do you want to add the PowerShell repo to the sources list?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      source /etc/os-release # Get the version of Ubuntu
      wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb # Download the Microsoft repository keys
      sudo dpkg -i packages-microsoft-prod.deb # Register the Microsoft repository keys
      rm packages-microsoft-prod.deb # Delete the Microsoft repository keys file
      break
      ;;
    'n'|'N') break ;;
  esac
done

# printf 'Do you want to add the Edge repo to the sources list?'
# select yon in 'y' 'n'; do
#   case $yon in
#     'y'|'Y')
#       wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
#       sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
#       break
#       ;;
#     'n'|'N') break ;;
#   esac
# done

sudo apt-get update
sudo apt-get upgrade

for t in "${progs[@]}"; do
  printf 'Installing %s\n' "$t"
  sudo apt-get -qq install "$t"
done

# Required for Android Studio
printf 'Installing android studio and dependancies\n'
sudo apt-get -qq install android-sdk lib32z1 libapr1 libapr1-dev libaprutil1-dev libbz2-1.0:i386 libc6:i386 libncurses5:i386 libstdc++6:i386

printf 'Do you wish to install NeoVim?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      # Install Neovim
      cd ~/ || return
      wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
      tar -xvzf nvim-linux64.tar.gz
      cd nvim-linux64 || (printf 'Unable to CD into nvim-linux64' && exit)
      sudo rsync -a ./bin/ /usr/bin/
      sudo rsync -a ./lib/ /usr/lib/
      sudo rsync -a ./share/ /usr/share/
      sudo rsync -a ./man/ /usr/local/man

      cd ~/ || return
      rm -rf ./nvim-linux64.tar.gz
      rm -rf ./nvim-linux64
      break
      ;;
    'n'|'N') break ;;
  esac
done

printf 'Do you want to install Ubuntu Mono NerdFont?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      # Install NerdFont
      cd ~/ || return
      wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf

      if [ ! -d "$HOME/.local/share/fonts/" ]; then
        mkdir -p "$HOME/.local/share/fonts/"
      fi

      sudo mv ./UbuntuMonoNerdFontMono-Regular.ttf ~/.local/share/fonts/
      sudo chmod 644 ~/.local/share/fonts/UbuntuMonoNerdFontMono-Regular.ttf
      break
      ;;
    'n'|'N') break ;;
  esac
done

printf 'Do you want to install neovim remote?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      # Install nvr
      pip3 install neovim-remote
      break
      ;;
    'n'|'N') break ;;
  esac
done

printf 'Do you want to install sqlfluff?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      pip3 install sqlfluff
      break
      ;;
    'n'|'N') break ;;
  esac
done

printf 'Do you want to install Node Version Manager?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      # Install nvm
      wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
      # shellcheck source=/home/travisp/.bashrc
      source ~/.bashrc
      nvm install node
      nvm use node
      break
      ;;
    'n'|'N') break ;;
  esac
done

sudo apt-get autoremove
sudo apt-get install --fix-missing
