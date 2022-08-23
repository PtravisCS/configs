function cdls {

  param (
    [string]$path = $( Read-Host "> ")
  )
  
  cd $path
  wsl ls

}

function mkcd {

  param (
    [string]$path = $( Read-Host "> ")
  )

  mkdir $path
  cd $path

}

function psrc {

  nvim $PROFILE 

}

<#
function Prompt {

  $gitBranch = $( git rev-parse --abbrev-ref HEAD ) 
  $ESC = [char]27
  $gitStatus = $( git status -bs | wsl grep -o '\\[[^]]*]' )

  if ($gitStatus -eq "" -or $gitStatus -eq $null) {

    $gitStatus = "[Up To Date]"

  }

  if ($gitBranch -eq $null -or $gitBranch -eq "") {

    '' + $(Get-Location) + '> ' 

  } else {

    $ESC + '[31m' + $gitBranch + " | " + $gitStatus + "$ESC[0m`n" + $(Get-Location) + '> '

  }

}
#>

function slm {

  cd "c:\Users\3364324\code\slm"

}

function potato {

  echo "Potato"

}

function edit_profile {

  nvim $PROFILE

}

New-Alias vi nvim
Set-PSReadLineOption -EditMode Vi
Import-Module -Name Terminal-Icons
Import-Module -Name posh-git

$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptPath.Text = "`n" + $GitPromptSettings.DefaultPromptPath.Text 

