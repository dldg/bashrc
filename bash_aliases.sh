#!/bin/bash

# =============================================================================
# ALIASES
# =============================================================================

# Safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias home='cd ~'

# Listing: GNU ls needs --color, BSD ls colours via CLICOLOR
if ls --color=auto -d . &>/dev/null; then
    __ls_color='--color=auto'
    alias ldir='ls -l --color=auto | grep "^d"'
else
    __ls_color=''
    alias ldir='ls -l | grep "^d"'
fi
alias ls="ls -Fh $__ls_color"
alias la='ls -A'                 # all files, except . and ..
alias ll='ls -Al'                # long listing, hidden files included
alias l='ls -C'
alias lk='ls -lSr'               # sort by size, largest last
alias lt='ls -ltr'               # sort by date, newest last
alias lr='ls -lR'                # recursive
unset __ls_color

# Utils
alias grep='grep --color=auto'
alias cls='clear'
alias vi='vim'
alias svi='sudo vim'
alias path='echo -e ${PATH//:/\\n}'
alias checkcommand='type -t'
command -v tree &>/dev/null && alias tree='tree -CAhF --dirsfirst'

# Git
alias gs='git status -s'
alias gsl='git status'
alias ga='git add'
alias gu='git add -u'
alias gst='git stash'
alias gstp='git stash pop'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gd='git diff'
alias gitlog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

# Disk (portable GNU/BSD flags)
alias diskspace='du -sh -- * .[!.]* 2>/dev/null | sort -rh | head -20'
alias folders='du -h -d 1 2>/dev/null | sort -h'
alias mountedinfo='df -h'
alias rebootsafe='sudo shutdown -r now'

# Processes and history
alias psg='ps -A | grep -i'
alias h='history'
alias j='jobs -l'

# SVN: print the working-copy root
alias svnroot="svn info 2>/dev/null | awk -F': ' '/Working Copy Root Path/ {print \$2}'"

# Linux desktop: notify after a long command, e.g. `make; alert`
if command -v notify-send &>/dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
