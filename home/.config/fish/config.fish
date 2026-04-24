if status is-interactive
    # Commands to run in interactive sessions can go here
end

# disable greeting
set fish_greeting

# Aliases
alias yay=paru
alias pacman=sudo pacman

# User paths
## Gowin IDE
## for IDE installed from AUR, doesn't work for now so import from manually installed one is needed as below
## fish_add_path /opt/gowin-eda-ide/bin 
if test -d $HOME/Tools/Gowin/IDE/bin
    fish_add_path $HOME/Tools/Gowin/IDE/bin
end
## my scripts
fish_add_path $HOME/.scripts
## Xilinx tools
### Xilinx base path
set xilinx_root $HOME/Tools/Xilinx
fish_add_path $xilinx_root/2025.2/Vitis/bin
fish_add_path $xilinx_root/2025.2/Vivado/bin

# local bin dir
fish_add_path /home/$USER/.local/bin

# display full path in prompt
set -U fish_prompt_pwd_dir_length 0

# >>> coursier install directory >>>
set -gx PATH "$PATH:$HOME/.local/share/coursier/bin"
# <<< coursier install directory <<<

# >>> rust binaries >>>
set -gx PATH "$PATH:$HOME/.cargo/bin"
# <<< rust binaries <<<
