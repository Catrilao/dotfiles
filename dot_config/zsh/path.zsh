setopt extended_glob null_glob

path=(
    $path
    $HOME/.local/bin
    /nix/store
    /mnt/c/Windows/System32
)

typeset -U path
path=($^path(N-/))

export PATH
