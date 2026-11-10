#!/usr/bin/env bash
# Installs the Google Workspace CLI (gws) if it is missing.
# Sourced from ~/.bashrc and ~/.zshrc; safe to run repeatedly.

gws_install() {
    command -v gws >/dev/null 2>&1 && return 0
    command -v npm >/dev/null 2>&1 || return 0

    echo "gws-install: installing @googleworkspace/cli" >&2
    npm install -g --silent @googleworkspace/cli >/dev/null 2>&1 ||
        echo "gws-install: npm install failed" >&2
}

gws_install
unset -f gws_install
