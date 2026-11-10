#!/usr/bin/env bash
# Installs the Atlassian CLI (acli) if it is missing, so the Stratus Jira
# integration has something to sign in. Sourced from ~/.bashrc and ~/.zshrc.

acli_install() {
    local system_bin="/usr/local/bin/acli"
    local arch tmp

    # Stratus's ~/.local/bin/acli wrapper execs this exact path.
    [ -x "$system_bin" ] && return 0
    command -v curl >/dev/null 2>&1 || return 0

    case "$(uname -m)" in
        x86_64 | amd64) arch=amd64 ;;
        aarch64 | arm64) arch=arm64 ;;
        *) return 0 ;;
    esac

    tmp=$(mktemp -d) || return 0
    echo "acli-install: installing acli" >&2
    if curl -fsSL -o "$tmp/acli" "https://acli.atlassian.com/linux/latest/acli_linux_${arch}/acli" &&
        chmod +x "$tmp/acli" && "$tmp/acli" --version >/dev/null 2>&1; then
        if sudo -n true 2>/dev/null; then
            sudo install -o root -g root -m 0755 "$tmp/acli" "$system_bin"
        elif ! command -v acli >/dev/null 2>&1; then
            mkdir -p "$HOME/.local/bin" && install -m 0755 "$tmp/acli" "$HOME/.local/bin/acli"
        fi
    else
        echo "acli-install: download failed" >&2
    fi
    rm -rf "$tmp"
}

acli_install
unset -f acli_install
