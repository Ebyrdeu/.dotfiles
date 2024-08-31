#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  source /etc/bash.bashrc
fi



alias fzf='fzf -m --preview="cat {}" --bind "enter:become(nvim {+})"'
alias ls='ls -a --color=auto'
alias grep='rg --color=auto'
alias e='nvim'
alias g='git'
alias ga='git add -p'
alias gaa='git add .'
alias gc='git commit -m'
alias gl='git log --stat'
alias glt="git log --graph --topo-order --pretty='%w(100,0,6)%C(#b57614)%h%C(bold)%C(#665c54)%d %C(#d65d0e)%ar %C(#689d6a)%an%n%C(bold)%C(#7c6f64)%s %N' --abbrev-commit"

# Docker
alias d="docker"
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# GPG
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
