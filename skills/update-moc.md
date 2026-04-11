# Skill: update-moc

Use this skill to create or update a Map of Content (MOC) for a topic.

---

## What is a MOC?

A Map of Content is an index note that links to every note on a given topic. It's the table of contents for a subject in your vault. Instead of searching every time, you open the MOC and see everything in one place.

Example: `MOC/Job-Matching.md` links to every note, ADR, meeting, and resource related to job matching.

---

## When to create a new MOC

Create a MOC when:
- A topic has 3 or more notes across different folders
- A project grows beyond a single folder
- The user explicitly asks for one

---

## MOC format

```md
# [Topic] — Map of Content

_Last updated: [date] by Connector_

---

## Decisions
- [[ADR-001-search-ranking]] — chose weighted scoring over ML model
- [[ADR-002-db-schema]] — normalized schema for HCP profiles

## Meeting notes
- [[2026-04-01-planning-meeting]] — initial scope defined
- [[2026-04-08-arch-review]] — approved service split

## Resources
- [[search-ranking-research]] — background reading on ranking algorithms

## Dev
- [[pr-142-search-service]] — implemented core ranking
- [[debug-search-latency]] — resolved P95 latency spike

## Daily / misc
- [[2026-04-11-standup]] — blocked on ranking spec
```

---

## Updating an existing MOC

When a new note is filed that relates to a MOC topic:
1. Open the existing MOC
2. Find the right section for the note type
3. Add a new line with the wikilink and a one-line description
4. Update the "Last updated" date

Never remove entries from a MOC — only add.

