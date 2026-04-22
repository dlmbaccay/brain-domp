---
name: log-workout
description: Updates today's workout file in-place with lifts, feel, and notes from user input.
---

# Skill: log-workout

Update today's workout file in `07-Fitness/workouts/` in place with the lifts, feel, and notes Dominic provided via `/coach`.

The file is typically created earlier in the day by Strava sync and contains an `## Auto-captured (Strava)` block with placeholders for everything else. This skill fills in those placeholders.

---

## Input formats accepted

Flexible natural language:

- "push day, bench 3x8 60kg, felt strong, 45min"
- "just did pull day, pullups felt good, rows were heavy"
- "legs, goblet squats 4x10 20kg, rdl 3x8 40kg, completed all sets"

Parse intent — don't ask clarifying questions for the first-pass log.

---

## Flow

1. Determine today's date (`YYYY-MM-DD`).
2. List `07-Fitness/workouts/` and find any file matching `YYYY-MM-DD-*.md`.
3. **If a file exists** (typical case — Strava synced this morning):
   - Read the file.
   - Parse frontmatter and section boundaries.
   - Update frontmatter `split_day:` to the split Dominic named (`push`, `pull`, `legs`).
   - Update frontmatter `tags:` to include the split-day slug. Example: `[workout, strength, push, merged]`.
   - Update the `# WeightTraining — YYYY-MM-DD` title to `# <Split Day> — YYYY-MM-DD` (e.g. `# Push Day — 2026-04-28`).
   - Replace the `## Lifts` section placeholder with the normalized lift log.
   - Replace the `## Feel` placeholder with feel info (one short phrase).
   - Replace the `## Notes` placeholder with notes (form cues, soreness, what to focus on next).
   - Replace the `## Related` placeholder with the relevant PPL wikilink (e.g. `- [[ppl-training-plan#push-1-strength]]` plus `- [[ppl-training-plan]]`).
   - **Preserve the `## Auto-captured (Strava)` section EXACTLY as-is.**
   - **Preserve frontmatter `date`, `sport`, `strava_id` EXACTLY as-is.**
   - Write the file back.
4. **If no file exists** (rare):
   - Create `YYYY-MM-DD-<split-day>.md` using the template below, with the `## Auto-captured (Strava)` section as a placeholder that Strava sync will later update.

---

## New-file template (rare case — no Strava file yet)

```md
---
date: YYYY-MM-DD
sport:
split_day: <push|pull|legs|rest|other>
strava_id:
tags: [workout, <split-day>, coach-logged]
---

# <Split Day> — YYYY-MM-DD

## Auto-captured (Strava)
_Pending — will populate on next Strava sync._

---

## Lifts
- <exercise> — <sets>x<reps> @ <weight>

## Feel
<one word or short phrase>

## Notes
<anything else — form cues, soreness, what to focus on next time>

## Related
- [[ppl-training-plan#<split>-1-strength]]
- [[ppl-training-plan]]
```

If no lifts were mentioned, the Lifts section reads `_not logged in detail_`.

---

## Lift parsing

Dominic logs lifts in natural language:

- "bench 4x8 at 60kg"
- "incline bench 4 sets of 8 reps at 60 kilograms"
- "db shoulder press 3x10 30lb"

Normalize to a consistent format in the Lifts section:

```
- Incline Barbell Press — 4x8 @ 60 kg
- Seated Shoulder Press — 3x10 @ 30 lb
```

- Em-dash (`—`) between exercise and sets/reps.
- `@` before weight.
- Keep units as given (kg / lb).
- Title-case exercise names.

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
- Dates always YYYY-MM-DD
- **Update existing files in place — do not create a second file for the same day**
- **Never modify the `## Auto-captured (Strava)` section** — that belongs to Strava sync
- **Never modify frontmatter `date`, `sport`, or `strava_id`** — those belong to Strava sync
- When the existing file has tags like `[workout, strength, merged]`, add the split slug to produce `[workout, strength, <split>, merged]`
