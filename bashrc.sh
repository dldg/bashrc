#!/bin/bash
# dldg/bashrc entry point. Sourced from ~/.bashrc (see install.sh).
# Works on Linux (GNU userland) and macOS (Homebrew bash 5, BSD userland).

# Interactive shells only
[[ $- != *i* ]] && return

DEVENV_OS=$(uname -s)   # Linux | Darwin
export DEVENV_OS

__devenv_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
for __devenv_f in exports functions options prompt aliases; do
    [ -r "$__devenv_dir/bash_$__devenv_f.sh" ] && source "$__devenv_dir/bash_$__devenv_f.sh"
done
unset __devenv_dir __devenv_f

# history -a: write each command immediately so parallel shells share history
PROMPT_COMMAND='__setprompt; history -a; __set_title'   # __setprompt first: it reads $?

# Machine-specific, untracked additions
[ -r "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
