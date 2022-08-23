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
HISTSIZE=100000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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


# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

#Allows cycling through options when pressing tab to autocomplete
bind '"\t":menu-complete'

#Set BASH to use vi mode to edit lines
set -o vi

mkcd() {
 mkdir $1
 cd $1
}

cdls() {
  cd $1
  ls
}

crlf2lf() {

  perl -p -e 's/\r$//' < $1 > tmpcrlf 
  mv tmpcrlf $1

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
        echo "Usage: statls [-ah] <file/director name>" 
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

  if [[ $all != 0 ]]
  then
    local file_list="$(ls -a $directory)"
  else
    local file_list="$(ls $directory)"
  fi

  local output=""

  for f in $file_list
  do
    output+="$f \t $(stat $f | egrep -o '\([0-9]{4}\/[dwrx-]{10}\)') \t $(file $f | cut -d ':' -f 2)\n"
  done

  echo -e $output | awk -F '\t' '{printf "%-30s %-14s %-30s\n", $1, $2, $3}'

}

gitBranch() {

  local gitBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) 
  echo "$gitBranch"

}

gitStatus() {

  local gitBranch=$(gitBranch) 

  if [[ -n "$gitBranch" ]]
  then
    local gitStatus=$(git status -bs 2>/dev/null | grep -o "\\[[^]]*]") 

    if [[ -z "$gitStatus" ]]
    then
      printf "$gitBranch | [Up To Date]\n "
    else
      printf "$gitBranch | $gitStatus\n "
    fi

  fi

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

# /033 = escape
# 0;31m = red
# 00m = reset
# 1;32m = light green 
# 01;34m = light blue

PS1='\[\033[0;31m\]$(gitStatus)\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PS1='$red$(gitStatus && echo "\n")$yellow${debian_chroot:+($debian_chroot)}$(echo $green)\u@\h$white:$blue\w$white\$ '
