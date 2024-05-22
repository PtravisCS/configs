alias cls='clear'
alias clclear='clear'
alias clcear='clear'
alias clclcear='clear'
alias cclear='clear'
alias del='rm'
alias restart='sudo shutdown 0 -r'
alias rust='rustc'
alias ghc='stack ghc --allow-different-user'
alias ghci='stack ghci --allow-different-user'
alias hello='echo hello, world'
alias top='sudo top -Eg'
alias please='sudo !!'
alias psh="pwsh"
alias powershell="pwsh"
#alias note='cd ~/notes && date +%c | cat >> `date +%F`; nvim $(date +%F); echo|tac >> `date +%F` && cd -'
alias lsnotes='tre ~/notes | less -X'
alias bc='bc -l'
#alias vi='nvr -s'
alias vi='nvim'
alias diff='nvim -R -d '
#alias diff='diff --color -y'
#alias vi='nvim --listen /tmp/nvimsocket'
alias ed='ed -v -p "* "'
alias red='ed -v -p "* "'
alias add='git add .'
alias s='git status'
alias c='git commit'
alias p='git push'
alias d='git d'
alias log='git log --full-history --stat --all --'
alias git-deleted='git log --diff-filter=D --summary --'
alias y='yes'
alias n='yes n'
alias python='python3'
alias weather='forecast'
alias s_client='openssl s_client'
alias docker='sudo docker'
alias list-installed='comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n "s/^Package: //p" | sort -u)'
