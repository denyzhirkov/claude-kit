---
name: orchestrate
description: Plan → dispatch → review loop for multi-agent work. Decompose a task into a plan file, route subtasks to scout/implementer/reviewer/expert, run independent ones in parallel, verify and close. Use when a task is above the triviality threshold and splits into ≥2 subtasks.
---
# Orchestrate

## 1. Size
Quick look (`Grep`/`Glob`, a few targeted `Read`s) → trivial / medium / large (CLAUDE.md → Delegation). Large → requirements intake first; write no plan until the spec is confirmed.

## 2. Plan
- Gather context yourself. Send `scout`s (in parallel, one question each) only for broad unknowns.
- Each subtask: declared file set, checkable acceptance criteria, fits one implementer context.
- Independence: disjoint file sets and no imports between them (`Grep` for imports of each file). Overlap or strong coupling → `depends`.
- Write `.claude/plans/<slug>.md`:
  ```
  # <story title>
  Goal: …   Out of scope: …   Test command: …
  ## S1 — <title>   [todo]
  Files: …   Depends: —   Acceptance: …
  ## S2 — …
  ```
- Medium → state the plan in ≤5 lines, proceed. Large → show the plan, wait for OK.

## 3. Dispatch
- Wave = subtasks with no open dependency. Launch all implementers of a wave in one message.
- Model per subtask: `implementer` as defined (Sonnet) for mechanical or well-bounded work; pass `model: "opus"` on the dispatch when the subtask carries design surface, tricky concurrency/state, or a public contract. A second review round costs more than the upgrade.
- Wave of 2+ implementers → each with `isolation: "worktree"` (repo must be git). A single implementer works in the main tree.
- After a wave: merge worktree changes back, run the tests, update statuses in the plan file before the next wave.

## 4. Review
- Each finished implementer → `reviewer` with the same brief + implementer report (+ worktree path if any).
- `CHANGES_REQUESTED` → SendMessage findings to the same implementer → re-review.
- After 2 failed rounds → `expert` with full history (brief, diffs, findings, failing output). Still stuck → escalate to the user.
- `APPROVE` → mark the subtask `done` in the plan file.

## 5. Close
- Full test suite (or the widest reasonable set) over the whole diff; review `git diff` once more yourself.
- Decisions/warnings worth keeping → project `CLAUDE.md` "Decisions" (or `docs/decisions.md`). Mark the story done.
- Report: what changed, test results, open issues.

## Brief template
```
Task: <slug>/S<n> — <title>
Goal: <one sentence>
Context: <findings, symbols, path:line>
In scope: <files>
Do not touch: <files / contracts>
Acceptance: <checkable criteria>
Test command: <exact command>
History: <escalations only — what was tried, findings, failing output>
Report: <what to return>
```
