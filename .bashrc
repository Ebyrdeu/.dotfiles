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



alias ls='ls -alh --color=auto'
alias grep='rg --smart-case --color=auto --line-number'
alias tree='ls -aR | grep ":$" | perl -pe '\''s/:$//;s/[^-][^\/]*\//    /g;s/^    (\S)/└── \1/;s/(^    |    (?= ))/│   /g;s/    (\S)/└── \1/'\'''

# Neovim
alias e='nvim'
alias vi='nvim'
alias vim='nvim'

# Git
alias g='git'
alias ga='git add -p'
alias gaa='git add .'
alias gc='git commit -m'
alias gl='git log --oneline --graph --decorate --all'
alias gp='git pull'
alias gpu='git push'
alias gf='git fetch --all --prune'

# Docker
alias d='docker'
alias dcont='docker container'
alias dcomp='docker compose'
alias drc='docker rm $(docker ps -aq)'
alias dri='docker rmi $(docker images -q -f dangling=true)'
alias drv='docker volume rm $(docker volume ls -q)'
alias dclean='docker system prune -af --volumes'
alias dpsa='docker ps -a'
alias dlsa='docker container ls -a'

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# For Tauri on X11
export WEBKIT_DISABLE_COMPOSITING_MODE=1

# zig
export PATH="$HOME/zig:$PATH"

PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# GPG
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude node_modules'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
