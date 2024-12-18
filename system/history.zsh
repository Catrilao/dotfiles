HISTSIZE=10000
HISTFILE="$XDG_STATE_HOME/zsh/history/.zsh_history"
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks
