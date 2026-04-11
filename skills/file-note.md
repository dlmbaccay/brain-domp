# Skill: file-note

Use this skill to determine the correct destination for a note in the vault.

---

## Step 1 — Read the note

Read the full content of the note. Identify:
- The main topic
- Any project names mentioned
- Any people mentioned
- The note type (meeting, decision, research, task, journal, dev artifact)

---

## Step 2 — Match against active projects

Read `Meta/profile.md` and get the active projects list.
If the note's topic clearly relates to an active project → route to `01-Projects/[project-name]/`

---

## Step 3 — Apply type routing

If no project match, use the note type:

| Note type | Destination |
|---|---|
| Meeting notes | `08-Meetings/` |
| Daily / standup | `06-Daily/` |
| PR review | `07-Dev/PRs/` |
| Debug session | `07-Dev/Debug/` |
| Retrospective | `07-Dev/Retros/` |
| Architecture decision | `02-Areas/Engineering/ADRs/` |
| API design notes | `02-Areas/Engineering/API-Design/` |
| Person / contact | `05-People/` |
| Article / research | `03-Resources/` |
| Completed work | `04-Archive/` |

---

## Step 4 — Confidence check

Rate your confidence: high / medium / low

- **High** — obvious match, move without asking
- **Medium** — reasonable match, move and mention it in the report
- **Low** — genuinely unclear, leave in Inbox and flag for user

---

## Filename conventions

Preserve the original filename when moving.
Exception: if the filename is too generic (e.g. `note.md`, `untitled.md`), rename it to `YYYY-MM-DD-[descriptive-slug].md` before moving.

