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
alias gc='git commit -m'
alias gl='git log --stat'



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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
