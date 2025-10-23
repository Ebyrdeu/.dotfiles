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
for file in ~/.config/bash/{aliases,prompt,functions,envs}; do
    [ -f "$file" ] && source "$file"
done