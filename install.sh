#!/usr/bin/env bash
# Ona runs this once when an environment is created. It hooks the startup
# scripts into shell startup so they run again after every restart.
set -euo pipefail

dotfiles_dir="$(dirname "$(readlink -f "$0")")"

for script in jira-login.sh glean-mcp.sh gws-install.sh; do
    path="$dotfiles_dir/$script"
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if ! grep -qsF "$path" "$rc"; then
            printf '\n[ -f "%s" ] && . "%s"\n' "$path" "$path" >>"$rc"
        fi
    done
    bash "$path"
done
