# Skill: debug-session

Use this skill to create and manage a debugging session note.

---

## Format — on open

```md
# Debug — [problem slug] — [date]

**Status:** open
**Started:** [time]
**Resolved:** —

---

## Problem

**Symptom:** [what the user is seeing — error message, unexpected behavior, etc.]
**Environment:** [where it's happening — local, staging, prod, which service]
**First seen:** [when did this start?]

## Already tried
- [thing tried] — [result]

---

## Investigation log

_[date time]_ — [starting point, first hypothesis]

---

## Resolution

_Leave this section empty until resolved._

---
tags: debug
related: []
```

---

## Updating during a session

As the user investigates, append to the Investigation log:

```
_[time]_ — [what was tried, what was found]
```

Keep each entry brief — this is a log, not an essay. The goal is to retrace your steps if you need to come back to it.

---

## Format — on resolve

When the user says it's resolved, update the note:

1. Change `**Status:** open` to `**Status:** resolved`
2. Fill in `**Resolved:** [time]`
3. Add the Resolution section:

```md
## Resolution

**Root cause:** [what was actually wrong]

**Fix:** [what was done to fix it]

**Prevention:** [how to avoid this in future, if applicable]

- [ ] [any follow-up tasks — docs update, test to add, ticket to file]
```

---

## Rules

- Never close the note until the user explicitly says it's resolved
- If the user gives up without resolving, mark status as "abandoned" and note the last known state
- Keep the investigation log chronological — never reorder or clean it up
- If a bug turns out to be worth an ADR (architectural issue discovered), tell the user and offer to create one

