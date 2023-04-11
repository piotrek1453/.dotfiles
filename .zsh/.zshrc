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
alias rmOrp='sudo pacman -Rns $(pacman -Qtdq)'
alias yays='yay -S'
alias yayup='yay -Syu'
alias python='python3'
alias pip='pip3'
alias lf='lfrun'

PS1='%n@%m %~$ '
#extra paths

fpath=(/home/juchap/.zsh/zsh-completions/src $fpath)
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.opam/default/bin:$PATH"
export TERMINAL="/usr/local/bin/st:$PATH"
export PATH="$HOME/juchap/.dwm:$PATH"
export PATH="$HOME/juchap/.local:$PATH"

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

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[white]%}[%{$fg[red]%}%n%{$fg[white]%}@%{$fg[green]%}%m | %~$ %{$fg[blue]%}${vcs_info_msg_0_}%{$fg[white]%}] '

#history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

#plugins
source /home/juchap/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/juchap/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/juchap/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# opam configuration
[[ ! -r /home/juchap/.opam/opam-init/init.zsh ]] || source /home/juchap/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null


