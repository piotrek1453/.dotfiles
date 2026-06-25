#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

### BEGIN GIMMICKS CONFIG ###

# Enable bash completion
[[ $PS1 &&
    ! ${BASH_COMPLETION_VERSINFO:-} &&
    -f /usr/share/bash-completion/bash_completion ]] \
    && . /usr/share/bash-completion/bash_completion

# Enable Starship prompt
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# === interactive shell only ===
if [[ $- == *i* ]]; then

    # === PATH additions ===

    # Gowin IDE
    if [ -d "$HOME/Tools/Gowin/IDE/bin" ]; then
        export PATH="$HOME/Tools/Gowin/IDE/bin:$PATH"
    fi

    # Xilinx tools
    XILINX_ROOT="$HOME/Tools/Xilinx"
    if [ -d "$XILINX_ROOT/2025.2/Vitis/bin" ]; then
        export PATH="$XILINX_ROOT/2025.2/Vitis/bin:$PATH"
    fi

    if [ -d "$XILINX_ROOT/2025.2/Vivado/bin" ]; then
        export PATH="$XILINX_ROOT/2025.2/Vivado/bin:$PATH"
    fi

    # local bin
    export PATH="$HOME/.local/bin:$PATH"

    # rust
    export PATH="$HOME/.cargo/bin:$PATH"

    # haskell (ghcup)
    if [ -d "$HOME/.ghcup/bin" ]; then
        export PATH="$HOME/.ghcup/bin:$PATH"
    fi

    # pnpm
    export PNPM_HOME="$HOME/.local/share/pnpm"
    if [ -d "$PNPM_HOME/bin" ]; then
        export PATH="$PNPM_HOME/bin:$PATH"
    fi

    # prompt setting equivalent (fish_prompt_pwd_dir_length)
    export PROMPT_DIRTRIM=0

fi

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
# Flyline - enhanced Bash experience
enable -f "$HOME/.local/lib/libflyline.so" flyline
