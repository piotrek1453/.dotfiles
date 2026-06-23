#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export QSYS_ROOTDIR="/home/juchap/.cache/paru/clone/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/25.1/quartus/sopc_builder/bin"

export STM32_PRG_PATH=/home/juchap/st/stm32cubeprogrammer/bin
### BEGIN MODERN BASH CONFIG ###

# Enable bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# Enable ble.sh (autosuggestions and syntax highlighting)
if [ -f "$HOME/.blesh/out/ble.sh" ]; then
    source "$HOME/.blesh/out/ble.sh"
fi

# Enable Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

### END MODERN BASH CONFIG ###

