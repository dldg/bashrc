#!/bin/bash

# =============================================================================
# FUNCTIONS
# =============================================================================

# Create a directory and cd into it
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find a file
function ff() {
    find . -iname "*$1*" -not -path '*/.git/*'
}

# Find a file and run a command on it
function fe() {
    find . -name "*$1*" -exec "${@:2}" {} \;
}

# Search for text in all files in the current folder
function ftext() {
    grep -iIHrn --color=always "$1" . | less -r
}

# Extract various archive types
function extract() {
    if [ ! -f "$1" ]; then echo "'$1' is not a valid file"; return 1; fi
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1"     ;;
        *.tar.gz|*.tgz)   tar xzf "$1"     ;;
        *.tar.xz|*.txz)   tar xJf "$1"     ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar)            tar xf "$1"      ;;
        *.bz2)            bunzip2 "$1"     ;;
        *.gz)             gunzip "$1"      ;;
        *.xz)             unxz "$1"        ;;
        *.zst)            unzstd "$1"      ;;
        *.rar)            unrar x "$1"     ;;
        *.zip)            unzip "$1"       ;;
        *.Z)              uncompress "$1"  ;;
        *.7z)             7z x "$1"        ;;
        *)                echo "'$1' cannot be extracted via extract()"; return 1 ;;
    esac
}

# Get current host related info
function ii() {
    local RED="\033[0;31m"
    local NC="\033[0m" # No Color
    echo -e "\nYou are logged on ${RED}${HOSTNAME:-$(hostname)}${NC}"
    echo -e "\nAdditional information:"
    uname -a
    echo -e "\n${RED}Users logged on:${NC}"
    w -h
    echo -e "\n${RED}Current date :${NC}"
    date
    echo -e "\n${RED}Machine stats :${NC}"
    uptime
    echo -e "\n${RED}Memory stats :${NC}"
    if command -v free &>/dev/null; then
        free -h
    else
        top -l 1 | head -n 10 | grep PhysMem
    fi
    echo -e "\n${RED}Local IP Address :${NC}"
    if command -v ip &>/dev/null; then
        ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
    else
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
    fi
}

# -----------------------------------------------------------------------------
# Developer helpers (C/C++ and processes)
# -----------------------------------------------------------------------------

# Grep only C/C++ sources. Usage: grepcpp [-p PATH] [grep flags] PATTERN
function grepcpp() {
    local path=$PWD
    if [ "$1" = '-p' ]; then
        path=$(cd "$2" && pwd) || return
        shift 2
    fi
    find "$path" -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.c' -o -name '*.cc' \
        -o -name '*.cpp' \) -print0 | xargs -r0 grep --color=always -Hn "$@"
}

# Find which static/shared libraries define or use a symbol.
# Usage: find_in_libs DIR SYMBOL
function find_in_libs() {
    local lib res
    while IFS= read -r -d '' lib; do
        res=$(nm -C "$lib" 2>/dev/null | grep -- "$2")
        [ -n "$res" ] && printf '%s:\n%s\n' "$lib" "$res"
    done < <(find "$1" -type f \( -name '*.a' -o -name '*.so*' -o -name '*.dylib' \) -print0)
}

# Find a string in files, highlighting it. Usage: fstr PATTERN [DIR|FILE-GLOB]
function fstr() {
    local dir=${2:-.} name='*'
    if [ -n "$2" ] && [ ! -d "$2" ]; then dir=$(dirname "$2"); name=$(basename "$2"); fi
    find "$dir" -type f -name "$name" -print0 | xargs -r0 grep -sin --color=always -- "$1"
}

# Ask a yes/no question; returns 0 on yes.
function ask() {
    local ans
    read -r -p "$* [y/n] " ans
    [[ $ans == [yY]* ]]
}

# My processes, optionally filtered: pp [PATTERN]
function pp() {
    ps -u "$USER" -o pid,%cpu,%mem,etime,command | awk 'NR==1 || (!/awk/ && $0 ~ pat)' pat="${1:-.*}"
}

# Kill my processes by name, asking for each. Usage: killps [-SIGNAL] PATTERN
function killps() {
    local sig=-TERM pid
    [ $# -eq 2 ] && { sig=$1; shift; }
    [ $# -eq 1 ] || { echo "Usage: killps [-SIGNAL] pattern"; return 1; }
    for pid in $(pgrep -u "$USER" -f -- "$1"); do
        [ "$pid" = "$$" ] && continue
        ask "Kill $pid <$(ps -o command= -p "$pid")> with $sig?" && kill "$sig" "$pid"
    done
}

# Run a command N times; stop early if it leaves a core dump. Usage: repeat N CMD...
function repeat() {
    local i max=$1; shift
    for ((i = 1; i <= max; i++)); do
        echo "Run $i/$max: $*"
        eval "$@"
        if compgen -G 'core*' >/dev/null; then echo "Aborted after $i runs (core dump)"; return 1; fi
    done
}

# Run a long command and pop a desktop notification when it finishes.
# Usage: notify_done make -j8
function notify_done() {
    local start=$SECONDS rc msg
    "$@"; rc=$?
    msg="'$*' finished (exit $rc) after $((SECONDS - start))s"
    if command -v notify-send &>/dev/null; then
        notify-send "Command finished" "$msg"
    elif command -v osascript &>/dev/null; then
        osascript -e "display notification \"$msg\" with title \"Command finished\""
    fi
    echo "$msg"
    return $rc
}
