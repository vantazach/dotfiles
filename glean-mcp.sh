#!/usr/bin/env bash
# Registers the Glean MCP server with Claude Code (user scope) if it is missing.
# Sourced from ~/.bashrc and ~/.zshrc; safe to run repeatedly.

glean_mcp() {
    local config="${CLAUDE_CONFIG_DIR:-$HOME}/.claude.json"

    command -v claude >/dev/null 2>&1 || return 0
    grep -qsF '"glean_default"' "$config" && return 0

    claude mcp add glean_default https://vanta-be.glean.com/mcp/default \
        --transport http \
        --scope user >/dev/null 2>&1 ||
        echo "glean-mcp: claude mcp add failed" >&2
}

glean_mcp
unset -f glean_mcp
