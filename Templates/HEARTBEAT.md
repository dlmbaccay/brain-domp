# Heartbeat Checklist

This file tells OpenClaw what to check and do on each scheduled tick.
Agents are invoked using the slash triggers defined in AGENTS.md.

Edit the intervals and prompts to match your schedule. Remove tasks you don't need.

---

tasks:
  - name: sort-inbox
    interval: 6h
    prompt: >
      Activate Sorter. Check 00-Inbox/ for any new notes and file them to their correct
      PARA folders. Report how many were moved and where. Skip if inbox is empty.

  - name: eod-digest
    interval: 1d
    when: weekday evenings around 7pm
    prompt: >
      Run the digest-work-eod skill. Synthesize a daily EOD digest from today's work
      vault daily notes and write it to 06-Daily/. Skip silently if
      the work vault is not present at vaults/work/.

  - name: weekly-aggregate
    interval: 1w
    when: Sunday mornings
    prompt: >
      Run the aggregate-week skill. Read the past 7 days of EOD digest files from
      06-Daily/ and synthesize a weekly summary. Write to
      06-Daily/YYYY-MM-DD-week-summary.md.

  - name: health-check
    interval: 1w
    when: Sunday evenings
    prompt: >
      Activate Librarian. Run a full vault health check across the vault.
      Write the report to Meta/health-report.md. Post a summary to the user.
