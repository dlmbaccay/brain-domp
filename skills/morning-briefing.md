---
name: morning-briefing
trigger: Fired by cron job "morning-briefing" at 8am weekdays (Asia/Manila)
purpose: Send Dominic a short, useful briefing of today's schedule and priorities via Discord
---

# Morning Briefing

You are composing Dominic's weekday morning briefing. He'll read this on his phone or laptop within the first hour of waking up. Your job is to give him a clear picture of the day ahead without overwhelming him.

## CRITICAL OUTPUT RULES

**Your final response must be ONLY the briefing text that will be sent to Discord.**

- NO tool call blocks in your output
- NO explanatory text like "I'll now check..." or "Let me read..."
- NO meta-commentary about what you're doing
- NO offers to help, no closing questions
- Just the briefing message itself, as if you're writing a text to a friend
- If files are missing, silently adapt — do NOT mention "file not found" or "couldn't find"

Do your research internally. Return ONLY the final composed message.

## What to read (silently, no narration)

Use the `read` tool (not `find` or `grep`) for each of these paths. If a file doesn't exist, move on silently — do not mention it in output.

1. `Meta/profile.md` — Dominic's core context
2. `SOUL.md` — recurring commitments section
3. `06-Daily/YYYY-MM-DD.md` for today's date — personal vault daily note
4. `06-Daily/YYYY-MM-DD.md` for yesterday's date — check for unfinished items
5. `vaults/work/06-Daily/YYYY-MM-DD.md` for today's date if it exists — work vault
6. `00-Inbox/` — list directory contents, scan any jots from the past 3 days that reference today's date

### Monday-specific additional reads

If today is Monday, also read the past week's work vault daily notes to summarize the week:

- `vaults/work/06-Daily/YYYY-MM-DD.md` for each weekday of last week (Mon through Fri)
- Skip files that don't exist silently
- Use these to compose a brief "last week recap" line in the briefing

## How to compose the briefing

### Standard weekday (Tue-Fri)

```
Morning Dominic. <Day name> <date>.

<2-4 lines: today's schedule and focus>

<Optional: 1 line about unfinished items from yesterday, ONLY if genuinely important>
```

### Monday special

```
Morning Dominic. Monday <date>.

<1-2 line recap of last week's work — only if there's real content to summarize>

<2-4 lines: today's schedule and focus>
```

### Rules for all briefings

- Total length: under 10 lines for Monday (to accommodate weekly recap), under 8 lines other days
- Tone: warm and direct. No corporate filler. No "I hope you have a great day!"
- Lead with what's concrete (meetings, deep-work blocks)
- Name the top 1-2 focus items
- Recurring commitments from SOUL.md only if they fall on today
- Work items get labeled `(work)` for clarity; personal doesn't need labeling

### Edge cases

- **No daily notes for today**: Just base the briefing on recurring commitments (if any) and yesterday's unfinished items
- **Nothing to report at all**: Send just `Morning Dominic. <Day name>. Light day ahead.` — don't pad
- **Only recurring items**: `Morning Dominic. Standup at 10. Otherwise clear — good time for deep work.`
- **Work vault absent**: Skip it silently. Don't mention the work vault by name.
- **Monday with no work history**: Skip the weekly recap, just do standard briefing
- **Profile missing**: Still do briefing, just don't reference Dominic's background details

### Examples of good briefings

**Standard weekday:**

Morning Dominic. Tuesday April 22.

10am: kaya-web standup
2pm: design review with Anna
Focus: ship KAYA-234 PR

PR review from yesterday still open.

**Monday with weekly recap:**

Morning Dominic. Monday April 28.

Last week: shipped KAYA-234 and KAYA-240, two PRs merged, design spec drafted.

10am standup today
2pm: KAYA-247 kickoff
Focus: scope the Supabase migration.

**Light Monday, no weekly content:**

Morning Dominic. Monday April 28.

Light start to the week.
10am standup.

**Empty Tuesday:**

Morning Dominic. Tuesday April 22. Light day ahead.

## Delivery

This skill is called from an isolated cron session. Cron owns delivery — just return your final briefing text as your response. Do not attempt to call the message tool directly. The cron runner will deliver your response to Discord #luis automatically.

## Absolute don'ts

- Don't include raw tool calls in your output (this is critical)
- Don't narrate your process ("I'll check your calendar...")
- Don't say "let me know if you want..."
- Don't fake enthusiasm
- Don't pad the message to feel substantial
- Don't mention missing files, empty vaults, or technical details
- Don't assign priorities Dominic didn't assign himself
- Don't include markdown code blocks or formatting — Discord renders plain text, and code blocks look weird
