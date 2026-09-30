#!/usr/bin/env bash
# Installs the orchestrator setup into ~/.claude. Existing files are backed up to *.bak.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DST="$HOME/.claude"
mkdir -p "$DST/agents" "$DST/skills/orchestrate"

backup_copy() { [ -f "$2" ] && cp "$2" "$2.bak"; cp "$1" "$2"; }

backup_copy "$SRC/CLAUDE.md" "$DST/CLAUDE.md"
for f in "$SRC"/agents/*.md; do backup_copy "$f" "$DST/agents/$(basename "$f")"; done
backup_copy "$SRC/skills/orchestrate/SKILL.md" "$DST/skills/orchestrate/SKILL.md"

# Merge model/effort into settings.json without touching other keys
S="$DST/settings.json"
[ -f "$S" ] || echo '{}' > "$S"
if command -v jq >/dev/null; then
  cp "$S" "$S.bak"
  jq '.model = "opus" | .effortLevel = "high"' "$S.bak" > "$S"
else
  echo "jq not found: add \"model\": \"opus\" and \"effortLevel\": \"high\" to $S manually"
fi
echo "Installed. Restart Claude Code and check /agents."
