---
name: create-adr
description: Creates a numbered Architecture Decision Record with context, options, decision, and consequences.
---

# Skill: create-adr

Use this skill to create an Architecture Decision Record.

---

## What is an ADR?

An Architecture Decision Record captures a significant technical decision — what was decided, why, and what the tradeoffs are. It's a permanent record that future-you and teammates can read to understand why the codebase is the way it is.

---

## Format

```md
# ADR-[NNN] — [Title]

**Date:** [date]
**Status:** proposed | accepted | deprecated | superseded by [[ADR-NNN]]
**Deciders:** [[name]], [[name]]

---

## Context

[What is the problem or situation that requires a decision?
What constraints exist? What forces are at play?
Write this as if explaining to someone who wasn't in the room.]

## Options considered

### Option 1 — [name]
[Description]

**Pros:**
- [pro]

**Cons:**
- [con]

### Option 2 — [name]
[Description]

**Pros:**
- [pro]

**Cons:**
- [con]

## Decision

**We chose Option [N] — [name]**

[Why this option? What was the deciding factor?
Be specific — "it was simpler" is less useful than "it reduces the number of service boundaries we need to maintain from 4 to 2".]

## Consequences

**Positive:**
- [what gets better]

**Negative:**
- [what gets harder or worse — be honest]

**Risks:**
- [what could go wrong]

## Follow-up
- [ ] [any actions needed as a result of this decision]

---
tags: adr, architecture
related: []
```

---

## Numbering

Before creating an ADR, list all files in `02-Areas/Engineering/ADRs/`.
Find the highest existing ADR number and increment by 1.
If no ADRs exist yet, start at ADR-001.

---

## Rules

- Status starts as "accepted" unless the user says it's still being discussed
- Always fill in "Consequences — Negative" — every decision has tradeoffs
- "Deciders" should include anyone who was part of the decision, wikilinked
- An ADR is never deleted — if superseded, update status and link to the new one

