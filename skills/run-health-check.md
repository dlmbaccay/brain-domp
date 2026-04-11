# Skill: run-health-check

Use this skill to audit the vault and produce a health report.

---

## Checks to run

### 1. Inbox age
- List all files in `00-Inbox/` with their creation date
- Flag any file older than 7 days as "stale inbox item"

### 2. Orphaned notes
- Find notes with no incoming wikilinks (nothing links to them)
- Find notes with no outgoing wikilinks (they link to nothing)
- These are candidates for linking or archiving

### 3. Broken wikilinks
- Scan all notes for `[[link]]` patterns
- Check if a note with that name exists anywhere in the vault
- Flag any link that points to a non-existent note

### 4. Stale projects
- List all folders in `01-Projects/`
- Check the most recent modification date of any file inside
- Flag projects with no activity in 30+ days

### 5. Duplicate detection
- Find notes with very similar titles (e.g. "auth-service.md" and "auth-service-notes.md")
- Flag pairs for user review — never merge automatically

### 6. Empty folders
- Find any vault folder with no `.md` files
- Flag for user awareness (might be intentional)

### 7. Inbox volume
- Count total notes in `00-Inbox/`
- If more than 10, flag as "inbox needs sorting"

---

## Health report format

Write to `Meta/health-report.md`:

```md
# Vault health report

**Date:** [date]
**Total notes:** [N]
**Vault age:** [days since profile.md created]

---

## Summary
[One paragraph overall health assessment]

## Issues found

### Stale inbox items ([N])
[list of files with age]

### Orphaned notes ([N])
[list of notes with no links]

### Broken wikilinks ([N])
[list of broken links with the note they appear in]

### Stale projects ([N])
[list of projects with last activity date]

### Possible duplicates ([N])
[list of pairs]

## Auto-fixed
[list of anything fixed automatically]

## Recommended actions
[prioritised list of what the user should do]
```

