#!/bin/zsh
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cpdir='pwd | xclip -selection clipboard'
alias vim='nvim'
alias pacman='sudo pacman'
alias pacs='sudo pacman -S'
alias pacup='sudo pacman -Syu'
alias yays='yay -S'
alias yayup='yay -Syu'

PS1='%n@%m %~$ '
#extra paths
export PATH=$PATH:~/scripts
PATH="$PATH:$HOME/.opam/default/bin"
export TERMINAL=/usr/local/bin/st

fpath=(/home/juchap/scripts/.zsh/zsh-completions/src $fpath)
fpath=(/home/juchap/scripts/.zsh/.zprompts $fpath)

autoload -U colors && colors
autoload -Uz promptinit
autoload -Uz compinit
promptinit
compinit
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '@%b'
#zstyle ':completion:*' menu select

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[white]%}[%{$fg[red]%}%n%{$fg[white]%}@%{$fg[green]%}%m | %~$ %{$fg[blue]%}${vcs_info_msg_0_}%{$fg[white]%}] '
neofetch


#exec startx
#while true
#	do
#	/usr/bin/dwm 2> /dev/null
#done

#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
#  exec startx &>/dev/null 
#fi

#plugins
source /home/juchap/scripts/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/juchap/scripts/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/juchap/scripts/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# opam configuration
[[ ! -r /home/juchap/.opam/opam-init/init.zsh ]] || source /home/juchap/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
