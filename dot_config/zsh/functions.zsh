function mkd {
    mkdir -p $1 && cd $1
}

function cl {
    rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' --bind shift-up:preview-page-up,shift-down:preview-page-down | awk -F ':' '{ print $3 }' | sed 's/^[[:space:]]*//' | pbcopy
}

function ol {
    v $(rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' --bind shift-up:preview-page-up,shift-down:preview-page-down | awk -F ':' '{ print "+"$2" "$1 }')
}
