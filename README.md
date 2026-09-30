# claude-kit

My Claude Code setup for orchestrator mode (scout / implementer / reviewer / expert subagents) — a version that works without the tsk and kungfu MCP servers.

## Contents

- `CLAUDE.md` — global rules: principles, the trivial / medium / large threshold, delegation.
- `agents/` — subagents:
  - `scout` (haiku) — codebase search, read-only;
  - `implementer` (sonnet) — one subtask per brief;
  - `reviewer` (opus) — read-only review, `APPROVE` / `CHANGES_REQUESTED`;
  - `expert` (fable) — escalation after 2 failed review rounds.
- `skills/orchestrate/SKILL.md` — plan → waves → review → close loop, plus the brief template.
- `install.sh` — copies everything into `~/.claude/` (existing files → `*.bak`), sets `model` and `effortLevel` in `settings.json` (requires `jq`).

## Install

```bash
git clone https://github.com/denyzhirkov/claude-kit.git
cd claude-kit && ./install.sh
```

Restart Claude Code and check `/agents` — the 4 agents should be listed.

## After install

- No `fable` on the account → set `model: opus` in `~/.claude/agents/expert.md`.
- 1M context available → set `"model": "opus[1m]"` in `~/.claude/settings.json`.
- Put the test command in each project's `CLAUDE.md` — implementer and reviewer rely on it.
- Parallel implementers run in git worktrees → the project must be a git repository.

## Usage

For anything above trivial: "do X via /orchestrate", or just describe the task — the rules in `CLAUDE.md` switch to orchestrator mode on their own. The plan is written to `.claude/plans/<slug>.md` in the project.
