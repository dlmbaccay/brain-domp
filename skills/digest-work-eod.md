---
name: digest-work-eod
description: Synthesizes a daily EOD digest from work vault daily notes and PR reviews. No-ops if the work vault is not present.
---

# Skill: digest-work-eod

Synthesize a daily end-of-day digest from work vault notes and write it to the personal vault.

---

## Step 1 — Check work vault presence

Look for `vaults/work/06-Daily/`. If it does not exist, stop and report:

```
Work vault not found at vaults/work/. Digest skipped.
To enable EOD digests, sync your work vault to vaults/work/ via Syncthing.
```

---

## Step 2 — Check last digest date

Read `Meta/last-digest.md`. If it does not exist, treat the last digest date as yesterday.

The file format is:
```md
# Last Digest

**Date:** YYYY-MM-DD
```

Collect all dates since the last digest date (exclusive) up to and including today.
If no dates are missing, stop and report: "Digest is up to date."

---

## Step 3 — Collect source notes

For each missing date:
1. Look for `vaults/work/06-Daily/YYYY-MM-DD*.md` — daily work notes for that date
2. Look for `vaults/work/07-Dev/PRs/YYYY-MM-DD*.md` — PR reviews created that date

If no source notes exist for a date, skip that date silently.

---

## Step 4 — Synthesize digest

For each date that has source notes, synthesize a digest. Read all source files for the date, then write:

```md
# Work EOD — YYYY-MM-DD

## What shipped / was reviewed
[2-4 bullets summarizing the main work — completed tasks, PRs reviewed, decisions made]

## Open threads
[any blockers, open questions, or carry-forward items from the day's notes]

## Notes
[anything worth remembering that doesn't fit the above — brief]

---
tags: eod, work-digest
related: []
```

Keep each digest tight — if the source notes are sparse, the digest should be sparse too. Never pad.

---

## Step 5 — Write digest files

Write each digest to `06-Daily/YYYY-MM-DD-work-eod.md`.

Never overwrite an existing digest file. If one already exists for a date, skip that date.

---

## Step 6 — Update last-digest.md

Write or update `Meta/last-digest.md` with today's date.

---

## Rules

- Never read or modify files outside `vaults/work/` (source) and `06-Daily/` (destination) and `Meta/last-digest.md`
- Never synthesize content that isn't in the source notes — no speculation
- If a source note is incomplete or garbled, capture what's there and note "[incomplete source]"
- Digest files are append-only — never edit a digest once written
