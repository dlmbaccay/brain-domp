---
name: morning-briefing
trigger: Fired by cron job "morning-briefing" at 8am weekdays (Asia/Manila)
purpose: Send Dominic a short, useful briefing of today's schedule and priorities via Discord
---

# Morning Briefing

You are composing Dominic's weekday morning briefing. He'll read this on his phone or laptop within the first hour of waking up. Your job is to give him a clear picture of the day ahead without overwhelming him.

## What to read

In order, scan these locations:

1. `Meta/profile.md` — Dominic's core context (already in your system prompt)
2. `SOUL.md` — recurring commitments section (already in your system prompt)
3. `06-Daily/YYYY-MM-DD.md` (today's date) — personal vault daily note
4. `06-Daily/YYYY-MM-DD.md` (yesterday's date) — check for unfinished items that carry over
5. `vaults/work/06-Daily/YYYY-MM-DD.md` (today's date, if file exists) — work vault daily note
6. `00-Inbox/` — scan for any jots in the past 3 days that reference today's date or are clearly scheduled for today

## How to compose the briefing

Structure your Discord message like this:

```
Morning Dominic. <Day name> <date>.

<2-4 lines of actual schedule / focus>

<Optional: 1 line about unfinished items from yesterday, ONLY if genuinely important>
```

### Rules

- Total length: under 8 lines
- Tone: warm and direct. No corporate filler. No "I hope you have a great day!"
- Lead with what's concrete (meetings, deep-work blocks)
- Then name the top 1-2 focus items
- Recurring commitments from SOUL.md are included only if they fall on today
- Work items get labeled `(work)` for clarity; personal doesn't need labeling

### Edge cases

- **Empty vault today**: If no daily note exists for today and no recurring commitments fall on today, send just "Morning Dominic. Light day ahead."
- **Only recurring items**: If the only thing today is recurring (e.g., Monday standup), say "Morning Dominic. Standup at 10. Otherwise clear — good time to go deep on something."
- **Unfinished from yesterday**: Only mention if it's 1-2 specific items. Don't list everything from yesterday.
- **Work vault absent**: If `vaults/work/06-Daily/<today>.md` doesn't exist, skip it silently. Don't mention the work vault.

### Examples of good briefings

**Busy day:**
```
Morning Dominic. Monday April 21.

10am: kaya-web standup
2pm: design review with Anna
Focus: ship KAYA-234 PR

Yesterday's PR review still open — might want to finish that first.
```

**Light day:**
```
Morning Dominic. Tuesday April 22.

No meetings today. Good chance to tackle the kaya-expo refactor you mentioned last week.
```

**Empty day:**
```
Morning Dominic. Wednesday April 23.

Light day ahead.
```

## Delivery

This skill is called from an isolated cron session. Cron owns delivery — just return your final briefing text as your response. Do not attempt to call the message tool directly. The cron runner will deliver your response to Discord #luis automatically.

## What not to do

- Don't include lengthy explanations or reasoning in the output
- Don't list every note in the vault — filter aggressively
- Don't fake enthusiasm
- Don't pad the message to feel substantial
- Don't offer to help with anything — this is a one-way broadcast
- Don't assign priorities Dominic didn't assign himself (no "you should prioritize X")
