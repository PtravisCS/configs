# shellcheck disable=SC1090,1091
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

bind '"\t":menu-complete'

set -o vi

mkcd() {

  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi

  cd "$1" || exit

}

cdls () {
	cd "$1" || exit
	ls
}

crlf2lf() {

	perl -p -e 's/\r$//' < "$1" > tmpcrlf
	mv tmpcrlf "$1"

}

statls() {
	while getopts "ah" o; do
		case "$o" in
			a)
				all=1;
				;;
			h)
				echo "Usage: statls [-ah] <file/director name>"
				echo "-a: displays hidden files"
				echo "-h: displays this help message"
				;;
			*)
				echo "Usage: statls [-ah] <file/directory name>"
				echo "-a: displays hidden files"
				echo "-h: displays this help message"
				;;
		esac
	done

	shift $(($OPTIND - 1));

	if [[ -z "$1" ]]
	then
    directory="."
	else
    directory=$1
	fi

  local file_list

	if [[ $all != 0 ]]
	then
    file_list="$(ls -a "$directory")"
	else
    file_list="$(ls "$directory")"
	fi

	local output=""

	for f in $file_list
	do
    output+="$f \t $(stat "$f" | grep -Eo '\([0-9]{4}\/[dwrx-]{10}\)') \t $(stat -c %U:%G "$f") \t $(file "$f" | cut -d ':' -f 2)\n"
	done

	echo -e "$output" | awk -F '\t' '{printf "%-30s %-14s %-20s %-30s\n", $1, $2, $3, $4}'

}

gitBranch() {

  local gitBranch
  gitBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo "$gitBranch"

}

gitStatus() {

  local gitBranch
  gitBranch=$(gitBranch)

  if [[ -n "$gitBranch" ]]
  then
    git fetch --multiple --no-tags 2>/dev/null
    behind=$(git rev-list --count "HEAD..@{u}" 2>/dev/null) 
    ahead=$(git rev-list --count "@{u}..HEAD" 2>/dev/null) 
    temp=$IFS
    IFS=$'\n'
    changed=($(git status --porcelain 2>/dev/null))
    IFS=$temp

    if [[ $behind -eq 0 ]] && [[ $ahead -eq 0 ]]; then
      gitstatus='[=]'
    elif [[ $behind -ne 0 ]] && [[ $ahead -eq 0 ]]; then
      gitstatus="[b: $behind]"
    elif [[ $ahead -ne 0 ]] && [[ $behind -eq 0 ]]; then
      gitstatus="[a: $ahead]"
    else
      gitstatus="[b: $behind | a: $ahead]"
    fi

    if [[ ${#changed[@]} -ne 0 ]]; then
      num_changes=${#changed[@]}
      change_string="[c: $num_changes]"
    fi

    printf "\u256D\u2574\uE0A0 %s | %s%s\n\u2570\u2574" "$gitBranch" "$gitstatus" "$change_string"
  fi

}

show() {
  if [[ -n "$1" ]]; then
    local commit="$1"
    shift
    git show "$commit" -- ':!*.min.map' ':!*.min.js' ':!*.min.js.map' "$@"
  else
    git show 
  fi
}

tree () {
	if command -v tre &> /dev/null
	then
		tre
		return
	fi

	if command -v tree &> /dev/null
	then
		tree
		return
	fi

	if command -v fd &> /dev/null
	then
    fd . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
		return
	fi

	printf "No valid tree solutions available.\n"
}

note() {

  local category
  printf "Category: "
  read -r category

  local topic
  printf "Topic: "
  read -r topic

  local path
  path=$(printf "%s/notes/%s" "$HOME" "$category")

  mkcd "$path"
  
	{ 
		printf -- "-------------------------------------"
		printf "\n%s\n%s\n" "$(date +%c)" "$topic" | cat
		printf -- "-------------------------------------"
	} >> "$topic"

  nvim "$topic"
  echo|tac >> "$topic"

  cd - || return

}

numFiles() {
  local globs=( )
  local OPTIND
  local opt
  
  while getopts "g:" opt; do
    case "$opt" in
      g)
        globs+=("$OPTARG")
        ;;
      *)
        printf "Invalid parameter. Usage: numFiles [-g '<glob>'] -- <search_term>\n"
        return
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local cmd

  for arg in "${globs[@]}"
  do
    cmd="${cmd} -g ${arg}"
  done

  printf "%s files\n" "$(rg -c "$cmd" -- "$1" 2>/dev/null | wc -l)"
}

numLines() {
  local globs=( )
  local OPTIND
  local opt
  local cmd
  local dir

  if ! command -v rg &> /dev/null
  then
    printf "Requires RipGrep to be installed in order to function.\n"
    exit 1
  fi
  
  while getopts "g:" opt; do
    case "$opt" in
      g)
        globs+=("$OPTARG")
        ;;
      *)
        printf "Invalid parameter. Usage: numLines [-g '<glob>'] -- <search_term>\n"
        return
        ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ -z "$1" ]
  then
    dir='.'
  else
    dir="$1"
  fi

  for arg in "${globs[@]}"
  do
    cmd="${cmd} -g ${arg}"
  done

  printf "%s lines\n" "$(rg -c "$cmd" -- "$dir" 2>/dev/null | cut -d':' -f2 | paste -sd+ | bc)"
}

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
default_colour=$(tput setaf 9)

rainbow() {

  for x in {0..8}; do 
      for i in {30..37}; do 
          for a in {40..47}; do 
              printf "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
          done
          echo
      done
  done
  printf "\n%s" "${default_colour}"

}

# All Escapes
#
# Color       Fore    Back
# --------    ----    ----
# Black       0;30    0;40
# Red         0;31    0;41
# Green       0;32    0;42
# Brown       0;33    0;43
# Blue        0;34    0;44
# Purple      0;35    0;45
# Cyan        0;36    0;46
# L-Gray      0;37    0;47
# D-Gray      1;30    1;40
# L-Red       1;31    1;41
# L-Green     1;32    1;42
# Yellow      1;33    1;44
# L-Purple    1;35    1;45
# L-Cyan      1;36    1;46
# White       1;37    1;47
#
# 0 - Normal Characters
# 1 - Bold Characters
# 4 - Underlined Characters
# 5 - Blinking Characters
# 7 - Reverse Video Characters
#
# ---------------
# CURSOR MOVEMENT
# ---------------
# [<l>;<c>H = Move cursor to line and column specified
# [<n>A     = Move cursor up N lines
# [<n>B     = Move the cursor down N lines
# [<n>C     = Move the cursor forward N columns
# [<n>D     = Move the cursor back N columns
# [2J       = Clear screen and move cursor to (0,0)
# [k        = erase to end of line
#
# -----------------
# ESCAPES I'M USING
# -----------------
# \[ = start non-printing characters
# \] = end non-printing characters
# \033 = escape
# [\1D = backspace cursor 1 character
# [0;31m = red
# [00m = reset
# [01;32m = light green
# [01;34m = light blue
# \u = user
# \h = host
# \w = path to working directory

PS1='\[\033[0;31m\]$(gitStatus)\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"
export PATH="$HOME/.local/bin:/home/travisp/.cargo/bin:$PATH"
#export MANPAGER="$HOME/.local/bin/nvr -s +Man!"
export MANPAGER="nvim -c 'Man!' -"
export XDG_CONFIG_HOME="$HOME/.config"
export DOTNET_CLI_HOME="$XDG_CONFIG_HOME"
