# General
alias ls='ls -alhrt --color=auto'
alias grep='rg --smart-case --color=auto --line-number'
alias yay='paru'

# Neovim
alias e='nvim'
alias vi='nvim'
alias vim='nvim'

# Git
alias g='git'
alias ga='git add -p'
alias gaa='git add .'
alias gc='git commit -m'
alias gst="git status"
alias gp='git pull'
alias gf='git fetch --all --prune'

# Docker
alias d='docker'
alias dcont='docker container'
alias dcomp='docker compose'

alias drc='docker rm $(docker ps -aq)'
alias dri='docker rmi $(docker images -q -f dangling=true)'
alias drv='docker volume rm $(docker volume ls -q)'
alias dclean='docker system prune -af --volumes'

alias dps='docker ps -a'
alias dls='docker container ls -a'
