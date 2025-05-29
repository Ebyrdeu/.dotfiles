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

# Source individual configuration files
for file in ~/.bash_{aliases,exports,functions}; do
    [ -f "$file" ] && source "$file"
done


PS1='\u@\h:\[\e[34m\]\w\[\e[0m\]\$ '

. "$HOME/.cargo/env"
. /usr/share/nvm/init-nvm.sh

# GPG
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude node_modules'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
