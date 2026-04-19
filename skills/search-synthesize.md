---
name: search-synthesize
description: Searches the vault across multiple locations and synthesizes a direct answer from what is found.
---

# Skill: search-synthesize

Use this skill to search the vault and synthesize an answer from what you find.

---

## Step 1 — Expand the query

Take the user's query and expand it into a search list:
- Original terms
- Synonyms and related concepts
- Abbreviations (e.g. "auth" for "authentication")
- Plural and singular forms

Example:
Query: "rate limiting decisions"
Search terms: rate limiting, throttling, API limits, request caps, quota, decided, decision, ADR

---

## Step 2 — Search strategy

Search in this order of priority:

1. `02-Areas/Engineering/ADRs/` — decisions live here
2. `01-Projects/` — active project context
3. `08-Meetings/` — meeting outcomes
4. `07-Dev/` — dev artifacts
5. `03-Resources/` — reference material
6. `06-Daily/` and `00-Inbox/` — recent captures

For each location, scan filenames first. Read full content only for files where the filename suggests relevance.

---

## Step 3 — Score relevance

For each note found, rate relevance:
- **High** — directly answers the query
- **Medium** — related context, useful background
- **Low** — tangentially related, skip unless nothing better found

Only include high and medium results in the response.

---

## Step 4 — Synthesize

Do not just list what each note says. Instead:
- Find the common thread across notes
- Identify the most recent or authoritative source on the topic
- Surface any contradictions or evolution of thinking over time
- Write a direct answer as if you've read everything and are now briefing the user

---

## Step 5 — Handle gaps

If the search returns nothing useful:
- Try broader terms
- Check if the concept might be filed under a different name
- If still nothing, report the gap honestly

