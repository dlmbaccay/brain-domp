# Skill: graphify-query

Use this skill to query a Graphify knowledge graph for a codebase.

---

## Step 1 — Resolve the codebase path

Read `Meta/profile.md` and find the `## Codebases` section.
Match the codebase name mentioned by the user (fuzzy match — "kaya" matches "kaya-expo").

If no match found:
```
I don't have a path registered for "[name]".
Add it to Meta/profile.md under ## Codebases:
- your-app-name: ~/path/to/your/app
```

If no `## Codebases` section exists in profile.md at all:
```
No codebases registered yet.
Tell the Architect: "add my codebases to profile"
```

---

## Step 2 — Check for Graphify output

Look for `[codebase-path]/graphify-out/GRAPH_REPORT.md`.

If it doesn't exist:
```
No Graphify output found for [name].
Run this in your codebase first:
  cd [path] && graphify .
Then try again.
```

---

## Step 3 — Read GRAPH_REPORT.md

Read the full `GRAPH_REPORT.md`. It contains:
- **God nodes** — the most connected, most important parts of the codebase
- **Community structure** — clusters of related code
- **Surprising edges** — unexpected connections between modules
- **Suggested questions** — what Graphify thinks is worth exploring

---

## Step 4 — Answer the query

Using the graph report as context, answer the user's question directly.

Format:
```
## [query restated]

[Direct answer based on the graph]

### Key nodes involved
- `[ClassName/function]` — [what it does, why it's relevant]

### Connections found
- `[A]` → `[B]` — [what this relationship means]

### Cross-references in vault
[If any vault notes mention these modules, link them here]
```

---

## Step 5 — Offer to cross-reference vault

After answering, always ask:
"Want me to check your vault for any notes, ADRs, or PR reviews related to these modules?"

If yes, pass the key node names to Seeker.

---

## Rules

- Only answer from GRAPH_REPORT.md — never guess about the codebase
- If the graph doesn't answer the question, say so and suggest running `/graphify .` again with more files
- Always show which codebase you queried so the user knows the context

