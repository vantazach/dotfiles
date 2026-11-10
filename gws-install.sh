#!/usr/bin/env bash
# Installs the Google Workspace CLI (gws) if it is missing and points it at
# the GWS_CREDENTIALS Ona secret. Sourced from ~/.bashrc and ~/.zshrc.

gws_setup() {
    local secret="$HOME/.config/gws/credentials.json"

    if ! command -v gws >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
        echo "gws-install: installing @googleworkspace/cli" >&2
        npm install -g --silent @googleworkspace/cli >/dev/null 2>&1 ||
            echo "gws-install: npm install failed" >&2
    fi

    # Ona mounts the secret into a root-owned ~/.config/gws, where gws cannot
    # write its cache, so give it a writable config dir instead.
    if [ -r "$secret" ]; then
        export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="$secret"
        export GOOGLE_WORKSPACE_CLI_CONFIG_DIR="$HOME/.cache/gws"
        mkdir -p "$GOOGLE_WORKSPACE_CLI_CONFIG_DIR"
    fi
}

gws_setup
unset -f gws_setup
