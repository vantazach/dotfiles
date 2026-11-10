#!/usr/bin/env bash
# Ona runs this once when an environment is created. It hooks jira-login.sh
# into shell startup so acli is logged in again after every restart.
set -euo pipefail

login_script="$(dirname "$(readlink -f "$0")")/jira-login.sh"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if ! grep -qsF "$login_script" "$rc"; then
        printf '\n# Jira login (once per boot)\n[ -f "%s" ] && . "%s"\n' \
            "$login_script" "$login_script" >>"$rc"
    fi
done

bash "$login_script"
