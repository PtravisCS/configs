#!/bin/bash 

# apt list --installed
# apt list --manual-installed | cut -d'/' -f'1'
progs=('7zip'
	'apache2'
	'aptitude'
	'astyle'
	'build-essential'
	'catimg'
	'clang-format'
	'clang'
	'clangd'
	'cowsay'
	'cpanminus'
	'curl'
	'diffutils'
	'docker-compose'
	'docker.io'
	'dos2unix'
	'fd-find'
	'findutils'
	'fping'
	'gcc'
	'gforth'
	'gimp'
	'git'
	'hardinfo'
	'htop'
	'imagemagick'
	'kate'
	'keepassx'
	'kolourpaint'
	'konsole'
	'libpar-packer-perl'
	'libperl-critic-perl'
	'libqt5sql5-psql'
	'libqt6sql6-psql'
	'lolcat'
	'lua5.4'
	'luarocks'
	'inkscape'
	'jello'
	'moria'
	'ncal'
	'net-tools'
	'nmap'
	'neofetch'
	'openssh-server'
	'parallel'
	'perl-doc'
	'perl'
	'php8.3'
	'php-fpm'
	'php-pear'
	'php-snmp'
	'php8.3-bcmath'
	'php8.3-bz2'
	'php8.3-common'
	'php8.3-curl'
	'php8.3-gd'
	'php8.3-gmp'
	'php8.3-igbinary'
	'php8.3-imagick'
	'php8.3-ldap'
	'php8.3-mbstring'
	'php8.3-mcrypt'
	'php8.3-mysql'
	'php8.3-opcache'
	'php8.3-pgsql'
	'php8.3-readline'
	'php8.3-redis'
	'php8.3-soap'
	'php8.3-sqlite3'
	'php8.3-xml'
	'php8.3-zip'
	'plocate'
	'podman'
	'postgis'
	'postgresql'
	'python3-pip'
	'python3-venv'
	'qmake6'
	'qt5-style-kvantum'
	'qt6-base-dev-tools'
	'qt6-base-dev'
	'qtcreator'
	'r-base'
	'recode'
	'rename'
	'ripgrep'
	'shellcheck'
	'sleuthkit'
	'smbclient'
	'solaar'
	'spell'
	'sshpass'
	'thunderbird-locale-en-gb'
	'thunderbird-locale-en-us'
	'thunderbird-locale-en'
	'timeshift'
	'traceroute'
	'tre-command'
	'ufw'
	'valgrind'
	'valkey-server'
	'vim'
	'vit'
	'vlc'
	'whois'
	'wine'
	'wireshark'
	'wl-clipboard'
)

printf -- 'Do you want to add the PowerShell repo to the sources list?\n'
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

printf -- 'Do you wish to install default programs?\n'
select yon in 'y' 'n'; do
	case $yon in
		'y'|'Y')
			for t in "${progs[@]}"; do
				printf 'Installing %s\n' "$t"
				sudo apt-get -qq install "$t"
			done

			# Required for Android Studio
			printf 'Installing android studio dependancies\n'
			sudo apt-get -qq install android-sdk lib32z1 libapr1 libapr1-dev libaprutil1-dev libbz2-1.0:i386 libc6:i386 libncurses5:i386 libstdc++6:i386
			;;
		'n'|'N') break;;
	esac
done

printf -- 'Do you wish to install NeoVim?\n'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      # Install Neovim
      cd ~/ || return
      wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
      tar -xvzf nvim-linux-x86_64.tar.gz
      cd nvim-linux-x86_64 || (printf 'Unable to CD into nvim-linux-x86_64' && exit)
      sudo rsync -a ./bin/ /usr/bin/
      sudo rsync -a ./lib/ /usr/lib/
      sudo rsync -a ./share/ /usr/share/
      sudo rsync -a ./share/man/ /usr/local/man

      cd ~/ || return
      rm -rf ./nvim-linux-x86_64.tar.gz
      rm -rf ./nvim-linux-x86_64
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

# Snaps
printf 'Do you want to install Snaps?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      snap install android-studio
      snap install chromium
      snap install code
      snap install firefox
			snap install powershell
			snap install tmux
			snap install rustup
      break
      ;;
    'n'|'N') break ;;
  esac
done

# Flatpaks
printf 'Do you want to install Flatpaks?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      flatpak install flathub com.google.AndroidStudio
      flatpak install flathub org.chromium.Chromium
      flatpak install flathub com.visualstudio.code
      flatpak install flathub org.mozilla.firefox
      break
      ;;
    'n'|'N') break ;;
  esac
done

# VSCode Plugins
printf 'Do you want to install VSCode Plugins?'
select yon in 'y' 'n'; do
  case $yon in
    'y'|'Y')
      pwsh ./vscode_plugins.ps1
      break
      ;;
    'n'|'N') break ;;
  esac
done

