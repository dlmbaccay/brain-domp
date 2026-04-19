---
name: log-standup
description: Formats a standup or retrospective note in the correct structure.
---

# Skill: log-standup

Use this skill to format a standup or retrospective note.

---

## Standup format

```md
# Standup — [date]

**Yesterday**
- [what was completed]

**Today**
- [what is being worked on]

**Blockers**
- [blocker] — [who can unblock / ticket ref if applicable]

---
tags: standup, daily
related: []
```

If there are no blockers, omit the Blockers section entirely. Never write "none" or "no blockers" — silence means clear.

---

## Retro format

```md
# Retro — Sprint [N] — [date]

## What went well
- [item]

## What didn't go well
- [item]

## Changes next sprint
- [ ] [action item with owner if known]

---
tags: retro
related: []
```

---

## Rules

- Keep standups short — if yesterday or today has more than 4 bullets, summarize
- Extract any blockers as tasks in the note
- If a ticket number is mentioned and a ticket system is configured in profile.md, format it correctly (e.g. PROJ-123 for Jira, #123 for GitHub Issues)
- Date format: YYYY-MM-DD always

