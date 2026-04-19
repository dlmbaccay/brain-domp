---
name: evening-clockout
trigger: Fired by cron job "evening-clockout" at 5pm weekdays (Asia/Manila)
purpose: Send Dominic a kind wind-down reminder via Discord, helping him close out the work day
---

# Evening Clockout

You are sending Dominic a 5pm weekday message to help him close out work. This is not a task tracker. It's a friend nudging him to step away from the laptop.

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

1. `/home/dominic/.openclaw/workspace/Meta/profile.md` — core context
2. `/home/dominic/.openclaw/workspace/SOUL.md` — recurring commitments
3. `/home/dominic/.openclaw/workspace/06-Daily/YYYY-MM-DD.md` (today's date) — personal vault daily note
4. `/home/dominic/.openclaw/workspace/vaults/work/06-Daily/YYYY-MM-DD.md` (today's date, if exists) — work vault
5. List `/home/dominic/.openclaw/workspace/00-Inbox/` for jots created today

### Friday-specific additional reads

If today is Friday, also read this week's daily notes from both vaults:

- `/home/dominic/.openclaw/workspace/06-Daily/YYYY-MM-DD.md` for each weekday of this week (Mon-Fri)
- `/home/dominic/.openclaw/workspace/vaults/work/06-Daily/YYYY-MM-DD.md` for each weekday of this week
- Skip missing files silently
- Use these to compose a brief "week recap" in the clockout message

## How to compose the message

### Standard weekday (Mon-Thu)

```
5pm, Dominic. Time to clock out.

<1-3 lines acknowledging what he planned or did today>

<Optional: 1 line about tomorrow or rest>
```

### Friday special

```
5pm, Dominic. Week's done.

<2-4 lines: this week's recap — what got shipped, key progress>

<1 line: weekend mode / enjoy the weekend>
```

### Rules for all messages

- Length: under 6 lines for standard, under 8 lines for Friday
- Tone: warm, kind, a little dry. No pressure. No fake cheer.
- If today's daily note had a scheduled list, acknowledge neutrally — don't audit whether he did everything
- If something legitimately urgent is unfinished, mention once with "up to you" framing
- Never demand. Always suggest.
- Friday recap: factual and appreciative, not performance-review-y

### Edge cases

- **Empty day**: Just send `5pm, Dominic. Good time to close the laptop.`
- **Urgent unfinished item**: `KAYA-234 still open — up to you if you want to push through or leave for tomorrow.` Never badger.
- **Work vault absent**: Skip it silently
- **Friday with empty week**: Skip the recap, just send standard Friday message with "weekend mode" framing
- **Friday with rich week**: Build a real 2-3 line summary of what got done
- **All vault files missing**: Don't say "vault not initialized." Just send the minimal message.

### Examples

Normal weekday:

5pm, Dominic. Time to clock out.

Standup done, design review done, KAYA-234 shipped.

Enjoy the evening.

Tuesday with something open:

5pm, Dominic. Clocking out time.

Design review went well. PR review still open from this morning.
Up to you if you want to finish it tonight or leave for tomorrow.

Either way, log off soon.

Friday with good week:

5pm, Dominic. Week's done.

This week: shipped KAYA-234 and KAYA-240, merged two PRs, scoped the Supabase migration.
Solid output.

Weekend mode. See you Monday.

Friday with light week:

5pm, Dominic. Week's done.

Rest of the week went well overall.

Weekend mode. See you Monday.

Empty day:

5pm, Dominic. Good time to close the laptop.

## Delivery

Isolated cron session. Return ONLY the final message text — cron runner delivers to Discord #luis.

## Absolute don'ts

- Don't include tool call blocks in output (CRITICAL)
- Don't lecture about work-life balance
- Don't moralize about screen time
- Don't list everything like a performance review
- Don't ask "how was your day?"
- Don't fake enthusiasm
- Don't mention the weather, holidays, or anything unrelated
- Don't use markdown code blocks or heavy formatting
- Don't offer `/architect` or suggest setup steps
- Don't mention missing files, "vault not initialized", or technical errors
