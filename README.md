# claude-kit

Мой сетап Claude Code для работы в режиме оркестратора (субагенты scout / implementer / reviewer / expert) — версия без tsk и kungfu MCP.

## Состав

- `CLAUDE.md` — глобальные правила: принципы, порог «тривиально / средне / крупно», делегирование.
- `agents/` — субагенты:
  - `scout` (haiku) — поиск по коду, read-only;
  - `implementer` (sonnet) — одна подзадача по брифу;
  - `reviewer` (opus) — read-only ревью, `APPROVE` / `CHANGES_REQUESTED`;
  - `expert` (fable) — эскалация после 2 неудачных раундов ревью.
- `skills/orchestrate/SKILL.md` — цикл план → волны → ревью → закрытие + шаблон брифа.
- `install.sh` — копирует всё в `~/.claude/` (старые файлы → `*.bak`), прописывает `model` и `effortLevel` в `settings.json` (нужен `jq`).

## Установка

```bash
git clone https://github.com/denyzhirkov/claude-kit.git
cd claude-kit && ./install.sh
```

Перезапустить Claude Code, проверить `/agents` — должны появиться 4 агента.

## После установки

- Если на аккаунте нет `fable` → в `~/.claude/agents/expert.md` поставить `model: opus`.
- Если доступен 1M-контекст → в `~/.claude/settings.json` `"model": "opus[1m]"`.
- В `CLAUDE.md` каждого проекта прописать команду тестов — её берут implementer и reviewer.
- Параллельные implementer'ы работают в git worktree → проект должен быть git-репозиторием.

## Использование

Для задачи крупнее тривиальной: «сделай X через /orchestrate» или просто описать задачу — правила из `CLAUDE.md` сами включат режим оркестратора. План пишется в `.claude/plans/<slug>.md` проекта.
