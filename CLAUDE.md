# Engineering principles

Default for any project; a repo's own `CLAUDE.md` overrides these.

## Philosophy

- Clear module boundaries, explicit contracts, no hidden coupling — code should survive changing requirements without rewrites.
- **Simple > clever.** YAGNI > DRY > purity. Extensibility is the absence of unnecessary coupling, not abstraction up front.
- **Hexagonal-light:** domain → ports → adapters; business logic never knows a provider SDK. One module, one responsibility — if a file starts serving two contexts, split it.

## Code

- Only the code the task needs. Prefer a parameter over a new abstraction — abstraction is the second user, not the first.
- No half-finished features, dead branches, or TODOs without a tracked issue.
- Business logic — pure functions taking ports as arguments; HTTP handlers stay thin.
- Money — `numeric`, never float. Time — UTC in the database, converted at the edge.
- Config centralized: env read through one validated module on startup; fail loud if anything is missing.
- No large refactors without an explicit request.
- Before calling work done, run the tests that cover it (the project's test command from its `CLAUDE.md`, narrowed to the touched area). Never report done on unrun code.

## Task size — one threshold, used everywhere

- **Trivial** = one file, no contract/schema change, no new dependency, fix obvious from the request (typos, wiring, small bugfixes). Just do it: no intake, no plan file, no delegation.
- **Above trivial** → intake before code: goal, explicit out-of-scope, acceptance criteria, affected contexts, contract/schema changes, failure mode of each new dependency. Anything unclear → ask via `AskUserQuestion`; an unasked question is a guessed requirement. Restate the spec in 3–5 lines and build once confirmed.
- The same threshold gates delegation (below).

## Response quality

- **Assumption audit (always on).** Verify load-bearing assumptions with a cheap call before any action with a side effect. Don't narrate the audit — but say it out loud when a check overturns an assumption.
- **Devil's advocate — design surface only** (schema/table change, new bounded context, public contract, adding/removing a dependency, auth or security): one short paragraph as the strongest critic, then incorporate it or say why it doesn't apply. Skip for routine execution.

## Communication

- Reply in the language of the question. Be concise: no preambles, no "here is what I did" — the diff shows it.
- Commit only when asked. No Claude attribution anywhere: no co-author tags in commits, no generated-with line in PR descriptions.

## Context retrieval

- Named symbol / known string → `Grep`; files by name → `Glob`; then `Read` only the relevant range (offset/limit), not whole large files.
- Broad unknown ("where does X live", many files) → delegate to `scout` (or built-in `Explore`) and keep only its conclusion.
- Before editing a symbol, find its callers (`Grep` for the name) — that is the blast radius.
- "Why is it like this?" → `git log -L` / `git log -p -- <file>` / `git blame` on the range.

## Memory

- Project decisions, gotchas, conventions → the project's `CLAUDE.md` (section "Decisions") or `docs/decisions.md`. Short, one bullet each, with the why.
- User profile / feedback / cross-session continuity → harness auto-memory.

## Task tracking

Plan for an above-trivial task lives in `.claude/plans/<slug>.md` in the repo: story goal, subtasks `S1..Sn` with file set, acceptance criteria, `depends: S…`, status (`todo / in-progress / review / done`). Only the orchestrator edits it. Carry the slug into the branch name and PR description.

## Delegation — orchestrator mode

Main session = orchestrator: plans, routes, verifies, closes. Subagents execute. Procedure and brief template: skill `orchestrate`.

- **Autonomy by size.** Trivial → do it myself. Medium (clear scope, obvious decomposition) → approve the plan myself, state it in ≤5 lines, proceed. Large (several contexts, contract/schema change, ambiguity) → full intake with the user before any dispatch.
- **Route by role:** `scout` (Haiku) — broad search; `implementer` (Sonnet) — one subtask per brief, override to `opus` per dispatch for a subtask with real design surface; `reviewer` (Opus) — independent read-only check; `expert` (Fable, or Opus if Fable is unavailable) — escalation only: two failed review rounds, bug with no clear root cause, unresolved design fork. Planning stays with the orchestrator. Agent frontmatter uses tier aliases — never pin a dated model id there.
- **Parallel only if independent:** subtasks with disjoint file sets and no import relationship between them (check with `Grep` for imports) form a wave → dispatch in parallel, each with `isolation: "worktree"`. Overlap → sequential (`depends`).
- **Nothing closes unreviewed:** implementer output goes to reviewer; findings return to the same implementer via SendMessage. Escalation ladder: 2 rounds → `expert` → user.
- **Memory:** only the orchestrator writes project decisions; subagents report blockers in their final report.
