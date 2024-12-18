# XDG Base directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Environment variables
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"

# Editors
export VISUAL=nvim
export EDITOR=nvim
