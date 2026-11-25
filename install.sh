#!/usr/bin/env bash
# Install dldg/bashrc for the current user. Idempotent: safe to re-run.
#   Linux: hooks ~/.bashrc
#   macOS: hooks ~/.bashrc, makes ~/.bash_profile source it, and offers to
#          switch the login shell to Homebrew bash 5 (+ bash-completion@2).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENTRY="$REPO_DIR/bashrc.sh"
BEGIN='# >>> dldg/bashrc >>>'
END='# <<< dldg/bashrc <<<'

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# Append a marked block to a file unless it is already there
add_block() { # file, block-body
    local file=$1 body=$2
    touch "$file"
    if grep -qF "$BEGIN" "$file"; then
        say "$file already hooked"
    else
        cp "$file" "$file.bak.$(date +%Y%m%d%H%M%S)"
        printf '\n%s\n%s\n%s\n' "$BEGIN" "$body" "$END" >>"$file"
        say "hooked $file (backup saved next to it)"
    fi
}

add_block "$HOME/.bashrc" "if [ -r \"$ENTRY\" ]; then source \"$ENTRY\"; fi"

if [ "$(uname -s)" = Darwin ]; then
    # Terminal.app and iTerm2 start login shells, which read ~/.bash_profile only
    add_block "$HOME/.bash_profile" 'if [ -r "$HOME/.bashrc" ]; then source "$HOME/.bashrc"; fi'

    if command -v brew >/dev/null; then
        say "installing Homebrew bash and bash-completion@2"
        brew install bash bash-completion@2
        BREW_BASH="$(brew --prefix)/bin/bash"
        if ! grep -qx "$BREW_BASH" /etc/shells; then
            say "adding $BREW_BASH to /etc/shells (sudo)"
            echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
        fi
        current_shell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
        if [ "$current_shell" != "$BREW_BASH" ]; then
            read -r -p "Change login shell from $current_shell to $BREW_BASH? [y/N] " ans
            [[ $ans == [yY]* ]] && chsh -s "$BREW_BASH"
        else
            say "login shell already $BREW_BASH"
        fi
    else
        say "Homebrew not found: install it from https://brew.sh, then re-run this script"
    fi
fi

say "done. Open a new terminal (or: source ~/.bashrc)"
