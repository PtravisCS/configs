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
alias ll='ls -alFh'
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

	local directory="."

	if [[ -n "$1" ]]
	then
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

# TODO: This should be moved into a different scripting language as a program, it's well past the point where BASH makes sense
# Finds the commit in which something was added/removed to/from the code base.
gitChanged() {
	help() { #intentionally nesting help function to avoid name conflicts
		if [[ -n "$1" ]]
		then
			printf "%s\n\n" "$1"
		fi

		printf "Usage: gitChanged <search_term> [<operation>] [<file_to_search>]\n"
		printf "<search_term> The term in the code that has been added/removed.\n"
		printf "<operation> (Optional) Whether the search term was added or removed. Should be a + for added and a - for removed. Default '-'.\n"
		printf "<file_to_search> (Optional) The file to look at for the added/removed search term.\n"
	}

	local search_term=""

	if [[ -n "$1" ]] && [[ "$1" != '-h' ]]
	then
		search_term="$1"
	else
		help 'Search term must be provided'
		return
	fi

	local operation="-"
	if [[ -n "$2" ]]
	then
		operation="$2"
	fi

	if [[ "$operation" != '-' ]] && [[ "$operation" != '+' ]]
	then
		help "Operation needs to be a '+' (added) or a '-' (removed)."
		return
	fi

	local file=""

	if [[ -n "$3" ]]
	then
		if [[ -f "$3" ]] || [[ -d "$3" ]]
		then
			file="$3"
		else
			printf "%s is not a valid file ignoring...\n" "$3"
		fi
	fi

	local searcher='rg'

	if ! command -v rg >/dev/null 2>&1
	then
		searcher='grep -E'
	fi

	#from start of line, after 0 or more whitespace, search for operation, 
	#0 or more of any character, then for the search term,
	#followed by 0 or more of any character
	local regex='^\s*'"$operation"'.*'"$search_term"'.*'

	#Get an array of only hashes from the log (--pretty='%H' limits the output to the format provided, %H is the hash)
	local commits=( $(git log --pretty='%H') )

	if [[ -n "$file" ]]
	then
		commits=( $(git log --pretty='%H' -- "$file") ) 
	fi

	printf "Search expression: '%s %s'\n" "$searcher" "$regex"
	printf "Searching through %i commit diffs\n" ${#commits[@]}

	local matches=0

	#Loops over commits in current repo (if file is provided then for current file) 
	#and for each one performs a diff from a previous commit to the next and greps that commit for 
	#a search term being removed, if one (or more) instances are found the commit SHA1 is echoed to the shell
	if [[ -f "$file" ]] || [[ -d "$file" ]]
	then
		for commit in ${commits[*]}
		do 
			if [[ $(git cat-file -t "$commit" 2>/dev/null) != 'commit' ]] 
			then
				printf "Commit %s not found\n" "$commit"
			elif [[ $(git cat-file -t "$commit^" 2>/dev/null) != 'commit' ]]
			then
				git show "$commit" | 
					$searcher '[iI]nitial [cC]ommit' >/dev/null || 
					printf "Commit %s^ not found\n" "$commit"
			else
				#-U specifies number of lines of context in the diff.
				git diff -U0 --ignore-space-change "$commit^" "$commit" -- "$file" | 
					$searcher "$regex" >/dev/null && 
					printf "%s\n" "$commit" &&
					((++matches))
			fi
		done
	else
		for commit in ${commits[*]}
		do
			if [[ $(git cat-file -t "$commit" 2>/dev/null) != 'commit' ]] 
			then
				printf "Commit %s not found\n" "$commit"
			elif [[ $(git cat-file -t "$commit^" 2>/dev/null) != 'commit' ]]
			then
				git show "$commit" | 
					$searcher '[iI]nitial [cC]ommit' >/dev/null || 
					printf "Commit %s^ not found\n" "$commit"
			else
				git diff -U0 --ignore-space-change "$commit^" "$commit" | 
					$searcher "$regex" >/dev/null && 
					printf "%s\n" "$commit" &&
					((++matches))
			fi
		done
	fi

	printf "Search completed. %i matches found.\n" "$matches"
}

gitDiff() {
	local branch=""

	if [[ -z "$1" ]]
	then
		branch=$(gitBranch)
	else
		branch=$1
	fi

	git d "$branch" -- ':!*.min*' ':!*.map*' ':!*.css*'
}

gitBranch() {

  local gitBranch
  gitBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  printf "%s\n" "$gitBranch"

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

#TODO: This doesn't work, the actual command in the subshell works, just not when run like this. I haven't done much testing as to why. It does work when run without globs and without specifying a directory it seems.
# List the number of lines in files matching the specified globs in the specified directory.
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

json() {
	if command -v python &> /dev/null
	then
		if [[ "$#" -ne 0 ]]
		then
			printf %s "$@" | python -m json.tool
		else
			python -m json.tool
		fi
	else
		printf "Python not installed, using grep and awk\n. The file must be provided over pipe\n"

		grep -Eo '"[^"]*" *(: *([0-9]*|"[^"]*")[^{}\["]*|,)?|[^"\]\[\}\{]*|\{|\},?|\[|\],?|[0-9 ]*,?' | awk '{if ($0 ~ /^[}\]]/ ) offset-=4; printf "%*c%s\n", offset, " ", $0; if ($0 ~ /^[{\[]/) offset+=4}'
	fi
}

xml() {
	if [[ "$#" -ne 0 ]]
	then
		printf %s "$@" | python -c 'import sys, xml.dom.minidom; print(xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml())'
	else
		python -c 'import sys, xml.dom.minidom; print(xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml())'
	fi
}

rename2() {
	local a=''
	local i=''
	local s=0
	local pattern=''
	local replacement=''
	local path='./*'

	local hasrename=0
	local hasfilerename=0

  if command -v rename.ul &> /dev/null
	then
		hasrename=1
	fi

	if command -v file-rename &> /dev/null
	then
		hasfilerename=1
	fi

	while getopts "aih" opt; do
    case "$opt" in
      a)
				a='-a '
        ;;
			i)
				i='-i '
				;;
			s)
				s=1
				;;
			h)
				printf "rename2 [-a] [-i] [-s] <pattern to replace> <replacement> [<path>]\n\t-a\tReplace all instances of pattern\n\t-i\tInteractively replace\n\nNote: switches -i and -s are ignored if Perl file-rename is installed"
				return
				;;
    esac
  done
  shift $((OPTIND - 1))

  if [ -n "$1" ]
  then
    pattern="$1"
  fi

  if [ -n "$2" ]
  then
    replacement="$2"
  fi

  if [ -n "$3" ]
  then
		path="$3"

		local REGEX='^.*(\*\.[A-Za-z0-9]+|\/\*)$'

		if [ $hasrename -eq 0 ] && [ $hasfilerename -eq 0 ] && [[ ! "$path" =~ $REGEX ]] # path has to end in a file glob, if it doesn't, assume *
		then
			path=$(sed -E 's/$/\/\*/' <<< "$path")
		fi
  fi

	if [ $hasrename -eq 1 ]
	then
		rename.ul "$a""$i""$pattern" "$replacement" "$path" 
	elif [ $hasfilerename -eq 1 ]
	then
		if [ "$a" = '-a' ]
		then
			file-rename "s/$pattern/$replacement/g" -- "$path"
		else
			file-rename "s/$pattern/$replacement/" -- "$path"
		fi
	else
		for file in $path
		do 
			local newname=$(sed -E "s/$pattern/$replacement/" <<< "$file")

			if [ "$a" = '-a ' ]
			then
				newname=$(sed -E "s/$pattern/$replacement/g" <<< "$file")
			fi

			if [ "$file" = "$newname" ]
			then
				continue
			fi

			if [ "$s" -eq 0 ]
			then
				printf "Renaming %s to %s\n" "$file" "$newname"
			fi

			if [ "$i" = '-i ' ]
			then
				local yon

				printf "Rename %s to %s (y|n)? " "$file" "$newname"
				read yon

				if [ ! "$yon" = 'y' ] && [ ! "$yon" = 'Y' ]
				then
					continue
				fi
			fi

			mv "$file" "$newname"
		done
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
# Fuller list here: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
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
export SYSTEMD_EDITOR="vim"
export GIT_EDITOR="$VISUAL"
export PATH="$HOME/.local/bin:/home/travisp/.cargo/bin:$PATH"
#export MANPAGER="$HOME/.local/bin/nvr -s +Man!"
export MANPAGER="nvim -c 'Man!' -"
export XDG_CONFIG_HOME="$HOME/.config"
export DOTNET_CLI_HOME="$XDG_CONFIG_HOME"
