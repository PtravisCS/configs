#Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Programming-Languages/Runtimes
choco install python3
choco install python2
choco install typescript
choco install jdk11
choco install jdk8

# IDEs
choco install vscode
choco install neovim

# Programming/Command-line Utilities
choco install microsoft-windows-terminal
choco install gsudo
choco install awscli
choco install docker-cli
choco install git
choco install hg
choco install powershell-core
choco install msys2

# Non-Choco Pacmans
choco install nvm
choco install maven

# User Applications
choco install audacity
choco install greenshot
choco install postman
choco install powertoys
choco install screentogif
choco install wireshark
choco install amazon-workspaces
choco install keypass
choco install powerbi

# Post Choco Installations
.\scripts\vscode_plugins.ps1
.\scripts\node_packages.ps1
.\scripts\neoVim.ps1
wsl --update
wsl --install --distribution Debian

