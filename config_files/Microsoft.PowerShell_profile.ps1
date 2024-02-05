# Functions
function cdls {

  param (
    [string]$path = $( Read-Host "> ")
  )
  
  Set-Location $path
  wsl ls

}

function mkcd {

  param (
    [string]$path = $( Read-Host "> ")
  )

  mkdir $path
  Set-Location $path

}

# Prompt Stuff
function gitBranch {

  $gitBranch = $(git rev-parse --abbrev-ref HEAD 2> $null)
  return $gitBranch

}

function gitStatus {

  $gitBranch = $(gitBranch)

  if ($gitBranch) {
    git fetch --multiple --no-tags 2> $null
    $behind = $(git rev-list --count HEAD..`@`{u`} 2> $null)
    $ahead = $(git rev-list --count `@`{u`}..HEAD 2> $null)
    $changed = $(git status --porcelain 2> $null)

    if ($changed) {
      $changed = $changed.Split([Environment]::NewLine)
    }

    if ([int]$behind -eq 0 -and [int]$ahead -eq 0 ) {
      $gitstatus = '[=]'
    } elseif ([int]$behind -ne 0 -and [int]$ahead -eq 0) {
      $gitstatus = "[b: $behind]"
    } elseif ([int]$ahead -ne 0 -and [int]$behind -eq 0) {
      $gitstatus = "[a: $ahead]"
    } else {
      $gitstatus = "[b: $behind | a: $ahead]"
    }

    if ($changed.Length -gt 0) { 
      $num_changes = $changed.Length
      $change_string = "[c: $num_changes]"
    }

    "`u{256D}`u{2574}`u{E0A0} $gitBranch | $gitstatus$change_string`n`u{2570}`u{2574}"
  }
}

function prompt {

  "$(
  Write-Host "$(gitStatus)" -NoNewLine -ForegroundColor red;
  Write-Host "$([Environment]::UserName)@$(hostname)" -NoNewLine -ForegroundColor green;
  Write-Host ":" -NoNewLine -ForegroundColor white;
  Write-Host "$(Get-Location)" -NoNewLine -ForegroundColor blue;
  )> "

}

# Alias Functions
function s { git status }
function add { git add . }
function p { git push }
function c { 
  Param (
    [Parameter(Mandatory=$false, Position=0)]
    [string] $params
  )

  if ($params) {
    git commit $params 
  }
  else {
    git commit
  }
}
function d { 
  Param (
    [Parameter(Mandatory=$false, Position=0)]
    [string] $params
  )

  if ($params) {
    git d $params 
  }
  else {
    git d
  }
}
function log { 
  Param (
    [Parameter(Mandatory=$false, Position=0)]
    [string] $params
  )

  if ($params) {
    git log --full-history --stat --all $params
  }
  else {
    git log --full-history --stat --all
  }
}
function show {
  Param (
    [Parameter(Mandatory=$false, Position=0)]
    [string] $params
  )

  if ($params) {
    git show $params -- ':!*.min.map' ':!*.min.js' ':!*.min.js.map'
  }
  else {
    git show
  }
}
function psrc { nvim $PROFILE }
function potato { Write-Output "Potato" }
function edit_profile { nvim $PROFILE }

# Aliases
New-Alias -Name "vi" nvim

if (-not (Test-Path alias:ls)) {
	New-Alias -Name "ls" dir
}

# Configurations and Modules
Set-PSReadLineOption -EditMode Vi
Import-Module -Name Terminal-Icons
Import-Module -Name posh-git


