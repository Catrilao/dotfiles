function mkd {
    mkdir -p $1 && cd $1
}

function cl {
    rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' --bind shift-up:preview-page-up,shift-down:preview-page-down | awk -F ':' '{ print $3 }' | sed 's/^[[:space:]]*//' | clip.exe
}

function ol {
    v $(rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' --bind shift-up:preview-page-up,shift-down:preview-page-down | awk -F ':' '{ print "+"$2" "$1 }')
}

function toggle_sudo() {
    [[ -z $BUFFER ]] && return

    if [[ $BUFFER == sudo\ * ]]; then
	BUFFER="${BUFFER#sudo }"
    else
	BUFFER="sudo $BUFFER"
    fi
    zle end-of-line
}
zle -N toggle_sudo
bindkey "^f" toggle_sudo

function ze() {
    if [ -z "$1" ]; then
        echo "Usage: ze <filename> (e.g., ze aliases.zsh)"
        return 1
    fi
    chezmoi edit --apply "$ZDOTDIR/$1"
}

function ct() {
    if [[ $# -eq 0 ]]; then
    	clip.exe
    else
	{
	    first=true
	    for file in "$@"; do
		if [[ -f "$file" ]]; then
		    if [[ "$first" = true ]]; then
			first=false
		    else
			echo ""
		    fi
		    cat "$file"
		else
		    echo "Warning: '$file' is not a file, skipping it" >&2
		fi
	    done
	} | clip.exe
    fi
}

function cf() {
    if [[ $# -eq 0 ]]; then
	echo "Usage: cf <file1> [file2 ...]" >&2
	return 1
    fi
    ct "$@"
}

function pt() {
    powershell.exe -NoProfile -Command "Get-Clipboard" | tr -d '\r'
}

