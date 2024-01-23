#Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
refreshenv

choco install audacity -y
choco install catimg -y
choco install clisp -y
choco install composer -y
choco install cpan -y
choco install cpanminus -y
choco install docker-cli -y
# choco install fd-find -y
# choco install ffmpeg -y
# choco install flake8 -y
choco install gforth -y
# choco install gimp -y
choco install git -y
choco install greenshot -y
choco install gsudo -y
choco install hg -y
# choco install imagemagick
# choco install inkscape
choco install jdk17 -y 
choco install jdk8 -y
choco install keypass -y
# choco install libpar-packer-perl
# choco install libperl-critic-perl
choco install maven -y
choco install microsoft-windows-terminal -y
choco install msys2 -y
choco install neovim -y
choco install nvm -y
# choco install php
choco install postman -y
choco install powershell-core -y
choco install powertoys -y
choco install python2 -y
choco install python3 -y
choco install rustup -y
# choco install ripgrep -y
choco install screentogif -y
choco install typescript -y
choco install vscode -y
choco install wireshark -y

# Post Choco Installations
refreshenv
.\scripts\vscode_plugins.ps1
.\scripts\node_packages.ps1
.\scripts\neoVim.ps1
.\scripts\powershell_modules.ps1
wsl --update
wsl --install --distribution Debian
