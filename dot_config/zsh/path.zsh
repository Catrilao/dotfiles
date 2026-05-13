setopt extended_glob null_glob

path=(
    $path
    $HOME/.local/bin
    /opt/nvim-linux64/bin
    $DOTNET_ROOT
    $DOTNET_ROOT/tools
    $NVM_DIR
    $HOME/scripts/
)

typeset -U path
path=($^path(N-/))

export PATH
