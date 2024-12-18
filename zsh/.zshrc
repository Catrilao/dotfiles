export DOTFILES="$HOME/dotfiles"

for file in $DOTFILES/system/*.zsh; do
    source $file
done

for file in $DOTFILES/git/*.zsh; do
    source $file
done

for file in $DOTFILES/zsh/*.zsh; do
    source $file
done


# Homebrew
# -----------------------------------------------------------------------------
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


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


# Shell integrations
# -----------------------------------------------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
