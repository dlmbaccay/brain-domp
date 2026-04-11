# Skill: summarize-pr

Use this skill to create a structured PR review note.

---

## Format

```md
# PR Review — [PR title or number] — [date]

**PR:** [number or link if provided]
**Author:** [[author name if known]]
**Reviewer:** [[your name from profile.md]]
**Status:** reviewed | approved | changes requested | merged

---

## What this PR does
[2-4 sentence summary of the change — what problem it solves, what it changes]

## Files / areas touched
- [key file or module] — [what changed]
- [key file or module] — [what changed]

## Concerns raised
- [ ] [concern] — [resolution if known, or "open"]

## Decisions made during review
- [any design decisions that came out of the review discussion]

## Follow-up tasks
- [ ] [anything that needs to happen after this merges]

---
tags: pr-review
related: []
```

---

## Rules

- The "Concerns raised" section is mandatory even if empty — write "none" if truly clean
- If the PR touches an area with an existing ADR, note it under related
- If the PR was authored by a team member, wikilink their name
- Status must be one of the four options — no custom values
- Focus on *decisions and concerns* — not just what the code does. That's the part worth remembering.

