---
name: create-links
description: Finds and adds meaningful wikilinks to a note, creating stub notes where needed.
---

# Skill: create-links

Use this skill to find and add meaningful wikilinks to a note.

---

## Step 1 — Extract linkable concepts

From the note content, identify:
- **People** — any person mentioned by name
- **Projects** — any project name that matches a folder in 01-Projects/
- **Decisions** — any reference to a decision that might have an ADR
- **Concepts** — recurring technical or domain concepts that appear in other notes
- **Events** — meetings, sprints, launches referenced by name

---

## Step 2 — Scan vault for matches

For each linkable concept:
1. Check if a note with that name already exists anywhere in the vault
2. Check if the concept appears as a significant topic in other notes
3. Check MOC/ for any thematic index that covers this concept

---

## Step 3 — Decide which links to add

Add a wikilink if:
- A note for that exact concept/person/project exists → `[[note-name]]`
- The concept is central to the note, not just a passing mention
- The link adds navigational value (user would genuinely want to jump there)

Do NOT add a wikilink if:
- The concept is mentioned only once in passing
- No relevant note exists and the concept is too minor to warrant one
- The note already links to it

---

## Step 4 — Add links in two places

1. **Inline** — replace the first meaningful mention of the concept in the body with `[[concept]]`
2. **Frontmatter** — add to the `related:` field at the bottom of the note

---

## Step 5 — Create stub notes if needed

If a person or project is mentioned frequently but has no note yet, create a minimal stub:

For a person:
```md
# [[Person Name]]

**Role:** [inferred from context]
**First mentioned:** [[source-note]]

---
tags: person
```

For a concept with no home:
```md
# [[Concept Name]]

_Stub created by Connector. Add content as you learn more._

**Appears in:** [[source-note]]

---
tags: concept
```

