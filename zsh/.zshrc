# XDG Base directory specification
# -----------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"


# Homebrew
# -----------------------------------------------------------------------------
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Path
# -----------------------------------------------------------------------------
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


# Enviromental variables
# -----------------------------------------------------------------------------
export VISUAL=nvim
export EDITOR=nvim


# Zinit Configuration
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"


# Prompt
# -----------------------------------------------------------------------------
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/prompt.toml)"


# Plugins
# -----------------------------------------------------------------------------
zinit ice lucid silent; zinit light zsh-users/zsh-syntax-highlighting
zinit ice lucid silent; zinit light zsh-users/zsh-autosuggestions
zinit ice lucid silent; zinit light zsh-users/zsh-completions
zinit ice lucid silent; zinit light Aloxaf/fzf-tab


# Snippets
# -----------------------------------------------------------------------------
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found


# Completions configuration
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu noj
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Keybindings
# -----------------------------------------------------------------------------
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^o' fzf-cd-widget


# Hitory
# -----------------------------------------------------------------------------
HISTSIZE=10000
HISTFILE="$XDG_STATE_HOME/zsh/history/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks


# Shell integrations
# -----------------------------------------------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"


# Aliases
# -----------------------------------------------------------------------------
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
