#Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
refreshenv

# Programming-Languages/Runtimes
choco install python3 -y
choco install python2 -y
choco install typescript -y
choco install jdk17 -y 
choco install jdk8 -y

# IDEs
choco install vscode -y
choco install neovim -y

# Programming/Command-line Utilities
choco install microsoft-windows-terminal -y
choco install gsudo -y
choco install docker-cli -y
choco install git -y
choco install hg -y
choco install powershell-core -y
choco install msys2 -y

# Non-Choco Pacmans
choco install nvm -y
choco install maven -y
choco install cargo -y

# User Applications
choco install audacity -y
choco install greenshot -y
choco install postman -y
choco install powertoys -y
choco install screentogif -y
choco install wireshark -y
choco install amazon-workspaces -y
choco install keypass -y
choco install powerbi -y

# Post Choco Installations
refreshenv
.\scripts\vscode_plugins.ps1
.\scripts\node_packages.ps1
.\scripts\neoVim.ps1
.\scripts\powershell_modules.ps1
wsl --update
wsl --install --distribution Debian
