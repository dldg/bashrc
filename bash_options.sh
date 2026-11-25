#!/bin/bash

# =============================================================================
# BASH OPTIONS
# =============================================================================

shopt -s checkwinsize   # update LINES/COLUMNS after each command
shopt -s histappend     # append to the history file, don't overwrite it
shopt -s cmdhist        # save multi-line commands as one entry
shopt -s cdspell        # fix minor typos in cd arguments
shopt -s checkhash      # check hashed commands still exist before running
shopt -s extglob        # extended pattern matching
if (( BASH_VERSINFO[0] >= 4 )); then
    shopt -s autocd     # type a directory name to cd into it
    shopt -s globstar   # ** matches recursively
    shopt -s dirspell   # fix typos in directory names during completion
fi

# =============================================================================
# HISTORY
# =============================================================================

export HISTSIZE=10000
export HISTFILESIZE=50000
export HISTTIMEFORMAT="[%d/%m %H:%M:%S] "
export HISTCONTROL=ignoreboth           # ignoredups + ignorespace
export HISTIGNORE='ls:ll:la:cd:pwd:exit:clear:history'

# =============================================================================
# COMPLETION AND LESS
# =============================================================================

# Make less friendlier for non-text input files (Linux)
command -v lesspipe &>/dev/null && eval "$(SHELL=/bin/sh lesspipe)"

# Programmable completion. bash-completion@2 on macOS needs bash >= 4.2.
if ! shopt -oq posix && (( BASH_VERSINFO[0] >= 4 )); then
    for __f in /usr/share/bash-completion/bash_completion /etc/bash_completion \
               "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash_completion.sh"; do
        if [ -r "$__f" ]; then . "$__f"; break; fi
    done
    unset __f
fi
