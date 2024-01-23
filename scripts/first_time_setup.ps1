#Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
refreshenv

[String[]]$progs = @(
  'audacity',
  '# catimg',
  '# clisp',
  'composer',
  '# cpan',
  '# cpanminus',
  'docker-cli',
  '# fd-find',
  '# ffmpeg',
  '# flake8',
  'gforth',
  '# gimp',
  'git',
  'greenshot',
  'gsudo',
  'hg',
  '# imagemagick',
  '# inkscape',
  'jdk17 ',
  'jdk8',
  'keypass',
  '# libpar-packer-perl',
  '# libperl-critic-perl',
  'maven',
  'microsoft-windows-terminal',
  'msys2',
  'neovim',
  'nvm',
  '# php',
  'postman',
  'powershell-core',
  'powertoys',
  'python2',
  'python3',
  'rustup',
  '# ripgrep',
  'screentogif',
  'typescript',
  'vscode',
  'wireshark'
)

foreach ($prog in $progs) {
  Write-Host "Installing $prog"
  choco install "$prog" -y
}

# Post Choco Installations
refreshenv
.\scripts\vscode_plugins.ps1
.\scripts\node_packages.ps1
.\scripts\neoVim.ps1
.\scripts\powershell_modules.ps1
wsl --update
wsl --install --distribution Debian
