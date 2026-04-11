# Contributing

Contributions are welcome. This is a small project — every PR gets read carefully.

---

## What's worth contributing

### Improving existing agents
If an agent's prompt produces bad output, file an issue with a reproducible example and open a PR with a better prompt. Attach before/after examples.

### Improving existing skills
Skills are the easiest place to contribute. If `capture-note.md` produces notes you don't like, change the format and submit it.

### New agents
Before building a new agent, open an issue first. Describe:
- What it does that existing agents don't
- What trigger it uses
- What skills it needs

New agents need a matching skill file if they introduce new output formats.

### New skills
Skills are reusable — if you find yourself writing the same instructions in multiple agent files, extract it into a skill. Name it as a verb: `create-x`, `log-x`, `summarize-x`.

### Platform support
If you get this working on a platform not listed (Cursor, Aider, etc.), a PR with the platform detection logic in `launchme.sh` and any config differences is very welcome.

---

## Structure

```
agents/        ← one .md file per agent
skills/        ← one .md file per reusable skill
Templates/     ← one .md file per note type
Meta/          ← system files, not user-edited
launchme.sh    ← installer
updateme.sh    ← updater
AGENTS.md      ← dispatcher
```

---

## Agent file structure

Every agent file must have these sections in this order:

```md
# [Agent name]

[One sentence description]

---

## Personality
[How this agent communicates]

---

## When you activate
[Triggers and conditions]

---

## What you do
[Step by step numbered process]

---

## Rules
[Hard constraints — things the agent must never do]
```

---

## Skill file structure

Every skill file must have these sections:

```md
# Skill: [skill-name]

[One sentence description]

---

## [Step or section]
[Content]

---

## Rules
[Hard constraints specific to this skill]
```

---

## Ground rules

- Agents never delete files — archive only. Do not submit PRs that add delete behavior.
- Keep agents focused. If an agent is doing two unrelated things, split it.
- Test your changes against a real vault before submitting.
- No external dependencies. Everything must work with plain markdown and file system operations.
- No platform-specific syntax in agent or skill files — they must work across all supported platforms.

---

## Submitting

1. Fork the repo
2. Create a branch: `git checkout -b agent/my-new-agent` or `fix/scribe-capture-format`
3. Make your changes
4. Open a PR with a clear description of what changed and why

