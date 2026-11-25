#!/bin/bash

# =============================================================================
# PROMPT
# =============================================================================
# (ERROR n)-(Tue Nov-25 14:03:07)-(user@host:~/git/repo)-(main)-(venv:.venv)
# >

# Current git branch, or short hash on a detached HEAD
function parse_git_branch() {
    git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

function __setprompt() {
    local last=$? # must come first

    local RED="\[\033[0;31m\]"
    local GREEN="\[\033[0;32m\]"
    local YELLOW="\[\033[1;33m\]"
    local BLUE="\[\033[0;34m\]"
    local CYAN="\[\033[0;36m\]"
    local GRAY="\[\033[1;30m\]"
    local NC="\[\033[0m\]"

    PS1=""
    if [[ $last != 0 ]]; then
        PS1+="${GRAY}(${RED}ERROR ${last}${GRAY})-"
    fi

    # Date & time via prompt escapes (no subprocesses, same on GNU and BSD)
    PS1+="${GRAY}(${CYAN}\D{%a %b-%d} ${BLUE}\D{%H:%M:%S}${GRAY})-"

    # User, host (only over SSH) and directory
    local host=""
    [[ -n $SSH_CONNECTION ]] && host="${GRAY}@${CYAN}\h"
    PS1+="(${RED}\u${host}${GRAY}:${YELLOW}\w${GRAY})"

    local branch
    branch=$(parse_git_branch)
    [[ -n $branch ]] && PS1+="-(${BLUE}${branch}${GRAY})"

    [[ -n $VIRTUAL_ENV ]] && PS1+="-(${GREEN}venv:${VIRTUAL_ENV##*/}${GRAY})"

    PS1+="\n"
    if [[ $EUID -ne 0 ]]; then
        PS1+="${GREEN}>${NC} "
    else
        PS1+="${RED}#${NC} "
    fi
}

# Terminal tab/window title = current directory name (xterm-compatible terminals)
function __set_title() {
    case "$TERM" in
        xterm*|rxvt*|screen*|tmux*|alacritty|wezterm) printf '\e]0;%s\a' "${PWD##*/}" ;;
    esac
}
