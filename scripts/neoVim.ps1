# Install vim-plug
Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    New-Item "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

# Install Nerd Fonts
Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf -OutFile "C:\Windows\fonts\DejaVuSansMono_NF.ttf"

Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf -OutFile "C:\Windows\fonts\UbuntuMonoNerdFontMono-Regular.ttf"
