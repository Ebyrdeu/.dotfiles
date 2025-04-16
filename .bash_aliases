alias ls='ls -alh --color=auto'
alias grep='rg --smart-case --color=auto --line-number'
alias tree='ls -aR | grep ":$" | perl -pe '\''s/:$//;s/[^-][^\/]*\//    /g;s/^    (\S)/└── \1/;s/(^    |    (?= ))/│   /g;s/    (\S)/└── \1/'\'''
alias treef='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'

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
