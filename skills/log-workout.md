---
name: log-workout
description: Captures a workout log from user input and files it in 07-Fitness/workouts/.
---

# Skill: log-workout

Capture a workout log from user input and file it in `07-Fitness/workouts/`.

---

## Input formats accepted

This skill accepts flexible input:

- Short: "day 1 push, bench 3x8 60kg, felt strong, 45min"
- Longer prose: "just did my pull day, pullups felt good, rows were heavy though, overall about 50 min"
- Minimal: "did push day"

Parse intent — don't ask clarifying questions for the first-pass log.

---

## Output format

```md
# [Day type] — [date]

**Split day:** [push | pull | legs | rest | other]
**Duration:** [if provided, else omit]
**Feel:** [one word from user context — strong/okay/tired/heavy/rushed/etc]

---

## Lifts
- [exercise] — [sets x reps @ weight]
- [exercise] — [sets x reps @ weight]

## Notes
[anything else — form cues, soreness, what to focus on next time]

---
tags: workout, [split-day-lowercase]
related: []
```

If no lifts were mentioned, the Lifts section reads `_not logged in detail_`.

---

## Filename

`YYYY-MM-DD-[split-day].md` saved to `07-Fitness/workouts/`

Examples:
- `2026-04-21-push.md`
- `2026-04-22-pull.md`
- `2026-04-23-legs.md`

---

## Agent message

After logging, post to `Meta/agent-messages.md`:

```
### [timestamp] Coach → Connector
**Trigger:** workout logged
**Context:** 07-Fitness/workouts/[filename]
**Action needed:** link exercise types to any existing MOC if present
**Priority:** low
---
```

---

## Rules

- Never invent weights or reps the user didn't provide
- Preserve what they said — don't add structure they didn't ask for
- If ambiguous, capture as-is — no clarifying questions for first-pass log
- Filename always matches split day (push/pull/legs/rest/other)
- Dates always YYYY-MM-DD
- Duration field is optional — omit entirely if not provided
