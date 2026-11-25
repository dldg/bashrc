#!/bin/bash

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Silence the "default interactive shell is now zsh" warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R -F -X'

# ls colours: GNU ls reads LS_COLORS, BSD (macOS) ls reads CLICOLOR + LSCOLORS
export CLICOLOR=1
export LSCOLORS='ExGxFxdaCxDaDahbadacec'
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.gz=01;31:*.bz2=01;31:*.xz=01;31:*.zst=01;31:*.7z=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.png=01;35:*.svg=01;35:*.mov=01;35:*.mp4=01;35:*.mp3=01;35:*.flac=01;35:*.wav=01;35'

# =============================================================================
# PATH
# =============================================================================

# Prepend a directory to PATH once, only if it exists
function __path_prepend() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac
}

# Homebrew (macOS Apple silicon, macOS Intel, Linuxbrew)
for __brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$__brew" ]; then eval "$("$__brew" shellenv)"; break; fi
done
unset __brew

# Go
if command -v go &>/dev/null; then
    export GOPATH=${GOPATH:-$HOME/go}
    __path_prepend "$GOPATH/bin"
fi

__path_prepend "$HOME/.cargo/bin"
__path_prepend "$HOME/.local/bin"
__path_prepend "$HOME/bin"
export PATH
