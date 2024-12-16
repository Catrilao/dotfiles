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
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"


# Homebrew
# -----------------------------------------------------------------------------
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Path
# -----------------------------------------------------------------------------
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
export PATH="$PATH:$NVM_DIR"


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
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^o' fzf-cd-widget


# Hitory
# -----------------------------------------------------------------------------
HISTSIZE=3000
HISTFILE="$XDG_STATE_HOME/zsh/history/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks


# Shell integrations
# -----------------------------------------------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"


# Aliases
# -----------------------------------------------------------------------------
alias v="nvim"
alias vz="nvim $ZDOTDIR/.zshrc"
alias so="source $ZDOTDIR/.zshrc"
alias c="clear"
alias cc="clear && code ."
alias ls="eza --icons --group-directories-first --oneline --no-quotes"
alias ll="eza --all --icons --group-directories-first --oneline --no-quotes"
alias tree="eza --tree --no-quotes"
alias fzf='fzf --preview "bat --style=plain --color=always {}"'
alias pf="fzf --preview 'bat --style=plain --color=always {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias bat="bat --style=numbers --color=always"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias buu="brew update; brew upgrade"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias cf="pbcopy < $1"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias sudo="sudo "

function mkd {
    mkdir -p $1 && cd $1
}

function copy-line {
    rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{ print $3 }' | sed 's/^[[:space:]]*//' | pbcopy
}

function open-at-line {
    v $(rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{ print "+"$2" "$1 }')
}
