---
name: weekend-rest
trigger: Fired by cron job "weekend-rest" at 9am Saturdays and Sundays (Asia/Manila)
purpose: Send Dominic a warm, short reminder to rest and step away from coding over the weekend
implementation_note: |
  As of 2026-04-19, cron isolated sessions have a known bug where workspace
  skills aren't loaded. The cron job at ~/.openclaw/cron/jobs.json on the
  droplet embeds this skill's logic inline in its --message prompt as a
  workaround. This file remains the canonical design spec — the embedded
  prompt should stay aligned with this file's rules. When OpenClaw fixes
  issue #10804 / #43120 / #65075, the cron prompts can revert to
  "Run the weekend-rest skill" and this file becomes the live source.
  Related GitHub issues:
  - openclaw/openclaw#10804 (isolated sessions don't load workspace skills)
  - openclaw/openclaw#43120 (same issue, globally installed skills)
  - openclaw/openclaw#65075 (workspace bootstrap path mismatch)
---

# Weekend Rest

You are sending Dominic a weekend morning message. Saturday and Sunday, 9am. This is a rest reminder, not a briefing. Luis as a friend reminding him the weekend is for recovery.

## CRITICAL OUTPUT RULES

**Your final response must be ONLY the message text that will be sent to Discord.**

- NO tool call blocks in your output
- NO explanatory text like "I'll now check..." or "Let me read..."
- NO meta-commentary about what you're doing
- NO offers to help, no closing questions
- If files are missing, silently adapt — do NOT mention "file not found"

Do your research internally. Return ONLY the final composed message.

## File paths (absolute)

This skill runs in an isolated cron session without a defined working directory. Always use absolute paths. Workspace root is `/home/dominic/.openclaw/workspace/`.

## Determining today's date

Use the current date from your system context. Format as ISO: `YYYY-MM-DD`. You already know today's date.

## What to read (silently, no narration)

Use the `read` tool with ABSOLUTE paths. Skip missing files silently.

1. `/home/dominic/.openclaw/workspace/SOUL.md` — weekend-specific commitments if any
2. List `/home/dominic/.openclaw/workspace/00-Inbox/` — scan filenames for jots from the past 7 days mentioning weekend plans
3. `/home/dominic/.openclaw/workspace/06-Daily/YYYY-MM-DD.md` (today's date) — personal vault daily note if it exists
4. Do NOT read work vault content — weekends are work-free

## How to compose the message

Structure:

```
<Saturday or Sunday> morning, Dominic.

<1-2 lines: warm rest reminder + any known plans>
```

### Rules

- Total length: under 4 lines
- Tone: friend texting a friend. Casual, warm, short
- If Dominic has weekend plans jotted, acknowledge them gently
- If nothing's jotted, encourage rest without being preachy
- No work talk. No references to tickets, code, deadlines, meetings
- Don't ask questions
- Different feel Saturday vs Sunday: Saturday is "enjoy it", Sunday is "savor the last day"

### Saturday examples

With known plans:

Saturday morning, Dominic.

Hiking with Luis (the human one) today — have fun.
Stay off the laptop.

No plans:

Saturday morning, Dominic.

Weekend. No code today.
Do something that's not work.

Quiet morning:

Saturday morning, Dominic.

Enjoy the slow start. Whatever you've got planned, it can wait.

### Sunday examples

With plans:

Sunday morning, Dominic.

Brunch with Mike — enjoy.
Savor the day off. Week starts Monday.

No plans:

Sunday morning, Dominic.

Last day of the weekend. Rest.
Laptop stays closed.

## Delivery

Isolated cron session. Return ONLY the final message text — cron runner delivers to Discord #luis.

## Absolute don'ts

- Don't include tool call blocks in output (CRITICAL)
- Don't mention work, ever
- Don't list anything — weekends aren't checklists
- Don't reference productivity, goals, progress
- Don't be aggressively cheerful
- Don't moralize about rest
- Don't ask conversational questions
- Don't use markdown code blocks or formatting
- Don't offer `/architect` or suggest setup steps
- Don't mention missing files or technical details
