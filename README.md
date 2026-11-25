# bashrc

Bash configuration shared by Linux (Ubuntu) and macOS.

| File | Contents |
|---|---|
| `bashrc.sh` | Entry point: loads the files below, then `~/.bashrc.local` if present |
| `bash_exports.sh` | `EDITOR`, colours, Homebrew/Linuxbrew, `PATH` |
| `bash_options.sh` | `shopt`, history, completion |
| `bash_prompt.sh` | Two-line prompt: exit code, time, user:dir, git branch, venv |
| `bash_aliases.sh` | Navigation, listing, git, disk, process aliases |
| `bash_functions.sh` | `mkcd`, `ff`, `extract`, `grepcpp`, `killps`, `notify_done`, … |

## Install

```bash
mkdir -p ~/git/dev-env && cd ~/git/dev-env
git clone https://github.com/dldg/bashrc
./bashrc/install.sh
```

The installer adds a marked block to `~/.bashrc` that sources `bashrc.sh`, and backs the file up first. On macOS it also:
- makes `~/.bash_profile` source `~/.bashrc`
- installs Homebrew `bash` and `bash-completion@2`
- offers to switch your login shell to Homebrew bash 5. The system `/bin/bash` is 3.2.

Re-running it is safe.

## Machine-specific settings

Put anything that belongs to a single machine (extra `PATH` entries, tokens, work proxies) in `~/.bashrc.local`. It is sourced last and is never committed.
