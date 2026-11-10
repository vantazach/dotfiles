#!/usr/bin/env bash
# Keeps the slack-vanta sign-in on the shared /efs drive so one
# `slack-vanta auth login` covers every Ona environment.
# Sourced from ~/.bashrc and ~/.zshrc; safe to run repeatedly.

slack_share() {
    local shared="${EFS_MOUNT_POINT:-/efs}/.config/slack-vanta"
    local local_dir="$HOME/.config/slack-vanta"

    [ -d "${shared%/*}" ] && [ -w "${shared%/*}" ] || return 0
    [ "$(readlink "$local_dir")" = "$shared" ] && return 0

    mkdir -p "$shared" && chmod 700 "$shared" || return 0

    if [ -d "$local_dir" ] && [ ! -L "$local_dir" ]; then
        # Keep a sign-in made before sharing was set up, unless one is already shared.
        if [ -f "$local_dir/token.json" ] && [ ! -f "$shared/token.json" ]; then
            mv "$local_dir/token.json" "$shared/token.json"
        fi
        mv "$local_dir" "$local_dir.bak.$(date +%s)" || return 0
    fi

    mkdir -p "${local_dir%/*}"
    ln -sfn "$shared" "$local_dir"
}

slack_share
unset -f slack_share
