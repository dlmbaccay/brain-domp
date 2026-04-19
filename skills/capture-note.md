---
name: capture-note
description: Transforms raw input into a clean, structured note using the user's preferred style.
---

# Skill: capture-note

Use this skill to transform raw input into a clean structured note.

---

## Output format — minimal style

Use this when the user's profile says style: minimal

```md
# [inferred title]

[date] · [project if applicable]

[cleaned up content in prose or loose bullets]

## Tasks
- [ ] [extracted task]
- [ ] [extracted task]

## People
- [[Person Name]]

---
tags: [inferred tags]
```

---

## Output format — structured style

Use this when the user's profile says style: structured

```md
# [inferred title]

**Date:** [date]
**Project:** [[project name]] or none
**Type:** note | decision | task | question

---

## Summary
[one sentence summary of the note]

## Content
[cleaned up content with clear headers if needed]

## Decisions
[any decisions made, or leave section out if none]

## Tasks
- [ ] [extracted task]
- [ ] [extracted task]

## Questions
[any unresolved questions, or leave section out if none]

## People
- [[Person Name]] — [their role in this note]

---
tags: [inferred tags]
related: []
```

---

## Rules for both styles

- Infer the title from the content — never use "Untitled" or "Note"
- Fix typos and grammar silently — never mention corrections to the user
- Keep the user's voice — rewrite for clarity, not for style
- Extract every task, no matter how small
- Tags should be 2-5 single words, lowercase, relevant to the content
- `related:` is left empty — Connector fills this in later
- Never add information that wasn't in the original input
- Never remove information that was in the original input

