#!/usr/bin/env bash
# Logs acli into Jira once per boot using the JIRA_API_TOKEN Ona secret.
# Sourced from ~/.bashrc and ~/.zshrc; safe to run repeatedly.

jira_login() {
    local stamp="$HOME/.cache/jira-login-boot-id"
    local email="${JIRA_EMAIL:-$ONA_INSTANCE_OWNER_EMAIL}"
    local boot_id

    [ -n "$JIRA_API_TOKEN" ] && [ -n "$email" ] || return 0
    command -v acli >/dev/null 2>&1 || return 0

    boot_id=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null)
    if [ -n "$boot_id" ] && [ "$(cat "$stamp" 2>/dev/null)" = "$boot_id" ]; then
        return 0
    fi

    if printf '%s' "$JIRA_API_TOKEN" | acli jira auth login \
        --site vanta.atlassian.net \
        --email "$email" \
        --token >/dev/null 2>&1; then
        mkdir -p "${stamp%/*}" && printf '%s' "$boot_id" >"$stamp"
    else
        echo "jira-login: acli jira auth login failed" >&2
    fi
}

jira_login
unset -f jira_login
