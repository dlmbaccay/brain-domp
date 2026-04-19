---
name: aggregate-week
description: Synthesizes a weekly summary from the past 7 days of EOD digest files.
---

# Skill: aggregate-week

Read the past 7 days of EOD digest files and synthesize a weekly summary.

---

## Step 1 — Collect EOD digests

Look for `06-Daily/*-work-eod.md` files with dates in the past 7 days (relative to today).

If no EOD digest files are found, stop and report:
```
No EOD digests found for the past 7 days.
Run `/dev eod` first to generate digests, then try again.
```

---

## Step 2 — Read and structure the digests

Read each digest file. For each, extract:
- **Date**
- **What shipped / was reviewed** section
- **Open threads** section

---

## Step 3 — Synthesize weekly summary

Write a summary covering the full week. Format:

```md
# Week Summary — [Monday date] to [Sunday date]

## Highlights
[3-5 bullets — the most significant things that happened this week across all days]

## By day
[For each day that has a digest — one line max per day]
- YYYY-MM-DD: [one-line summary]

## Carry-forward
[Any open threads from EOD digests that are still unresolved — deduplicated]

## Patterns
[Optional: any recurring themes, blockers, or observations across the week worth noting]

---
tags: week-summary, work-digest
related: []
```

---

## Step 4 — Write the summary

Write to `06-Daily/YYYY-MM-DD-week-summary.md` where the date is today.

Never overwrite an existing summary. If one already exists for today, append `-2` to the filename.

---

## Rules

- Base the summary only on the EOD digest files — do not read the raw work vault notes
- If a day in the past 7 days has no digest, omit it from "By day" without comment
- Keep "Highlights" to 3-5 bullets maximum — synthesize, don't list everything
- "Patterns" is optional — only include if something genuinely recurring stands out
