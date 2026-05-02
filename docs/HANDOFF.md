# Handoff: Phase 1 — brain-domp OpenClaw Support

> **Historical context only.** Phase 1 has been executed. This document records the design decisions and planning from the prior conversation that produced this branch. It is not active instructions — refer to the code and `README.md` for current state.

---

> Original handoff note (preserved for context):
> Read this whole document before doing anything. It carries context from a prior Claude conversation that established all the design decisions. Your job is to execute Phase 1 — you do NOT need to re-litigate the decisions below.

---

## Who you're working with

- **Dominic** (GitHub: `dlmbaccay`), full-stack web/mobile dev at a healthcare platform for HCPs
- Owns this `brain-domp` repo upstream — this isn't a fork
- Working on personal MacBook Pro M3 (user: `dominic`)
- Also has a work MacBook Pro M4 (user: `dbaccay`), not involved in this work

## What brain-domp is

A crew of 7 markdown-defined AI agents that manage a knowledge vault. The repo's `README.md` and `CONTRIBUTING.md` are the authoritative product description — read them first.

Current supported platforms: Claude Code, OpenCode, Gemini CLI. Platform detection lives in `launchme.sh`.

## The bigger picture (context, not scope)

Dominic is building a 24/7 OpenClaw-based personal AI assistant that will eventually run on an Oracle Cloud Free Tier VM in Singapore, receive inputs via Discord, and work alongside his two laptops via Syncthing. The work laptop produces vault content automatically (via a `/ship-it` slash command and a SessionEnd hook, already installed), Syncthing pushes to the VM, and OpenClaw processes everything there.

**Phase 1 is: update brain-domp to support OpenClaw as a fourth platform, plus a few related improvements.** That's the entire scope of this session. Oracle VM provisioning, Syncthing config, Discord bot setup, OpenClaw daemon work — all out of scope. Phase 1 is pure engine changes to this repo.

## Design decisions already locked in

Do not re-discuss these. Execute them.

### Rename: Scribe → Jot

The agent currently called Scribe is being renamed to Jot throughout the repo. This is a consistency-critical rename — any stale "Scribe" reference will break the dispatcher. All files that mention Scribe need updating:

- `agents/scribe.md` → rename to `agents/jot.md`, update internal references
- `skills/capture-note.md` — references Scribe, update
- `AGENTS.md` — dispatcher table, routing rules, trigger patterns
- `agents/sorter.md` — triggers reference Scribe's messages
- `agents/connector.md` — same
- `agents/architect.md` — possibly
- `Meta/agent-messages.md` — example format
- `README.md` — agent table, philosophy
- `CONTRIBUTING.md` — Scribe referenced as example
- `launchme.sh` — filename reference

Slash triggers: `/scribe` becomes `/jot` throughout. Keep the slash convention (used for OpenClaw and the dispatcher).

### OpenClaw platform support (the main work)

Add `openclaw` as a fourth platform in `launchme.sh` alongside `claude-code`, `opencode`, `gemini-cli`. OpenClaw specifics:

- **Auto-detection:** `~/.openclaw/` exists OR `openclaw` command on PATH
- **Config dir:** `~/.openclaw/workspace/`
- **Dispatcher filename:** `AGENTS.md` (same as OpenCode — OpenClaw reads this natively)
- **Skills format:** folder-per-skill, each skill is `~/.openclaw/workspace/skills/<skill-name>/SKILL.md` (NOT the flat file format other platforms use). The installer must convert flat `skills/*.md` files to the folder format when installing for OpenClaw.
- **Additional files generated:**
  - `~/.openclaw/workspace/SOUL.md` — OpenClaw's identity/personality/rules file. Maps to brain-domp's `Meta/profile.md`. Generated from profile data.
  - `~/.openclaw/workspace/HEARTBEAT.md` — OpenClaw's scheduled task checklist. New concept for brain-domp, includes default entries for Sorter (every 6h), EOD digest (weekday 7pm), weekly aggregate (Sunday morning), Librarian health check (Sunday evening).

### Scenario 2: multi-platform on one machine

Dominic uses Claude Code, OpenCode, and Copilot on the personal laptop, switching between them. Phase 1 must support installing agents to **multiple platforms simultaneously** on the same machine (current `launchme.sh` assumes one platform per install).

Add a `--platforms` flag (comma-separated) OR an `--all-detected` flag that installs to every detected platform. Pick whichever API feels cleaner — I'd suggest `--platforms claude-code,openclaw` for explicit control plus `--all` for shortcut.

**Use symlinks by default** for multi-platform install — one canonical file in the repo, symlinks from each platform's config dir pointing to it. Add a `--copy` escape hatch for the rare case someone wants independent copies. Symlinks mean editing the repo updates all platforms instantly, no drift.

GitHub Copilot is in Dominic's stack but I don't know its exact config file convention. **Before implementing Copilot support, check the current GitHub Copilot docs for where agent/skill prompt files live** (`.github/copilot-instructions.md` likely, but verify). If the conventions don't cleanly fit brain-domp's structure, it's fine to leave Copilot as a stub with a TODO — we can add proper support later. Don't fake it.

### Path 1 execution model

When agents are invoked locally (via Claude Code, OpenCode, Copilot), they do their work directly against the local vault filesystem. They do NOT need to talk to the Oracle VM. The OpenClaw daemon on the VM runs its own copy of the agents for Discord-initiated requests. Syncthing keeps both vault views consistent.

Concretely: a `/jot` invocation in local Claude Code writes to `/Users/dominic/Documents/Vault/brain-domp-vault/00-Inbox/YYYY-MM-DD-slug.md` directly. Nothing else.

### Hybrid Discord channel model

Out of scope for Phase 1 but mentioned for context — when OpenClaw is deployed on the VM, it'll use a single `#openclaw` Discord channel plus bot DMs for sensitive content. Phase 1 doesn't touch Discord setup.

### Mixed model routing

For OpenClaw on the VM, the model routing will be:

- **meta-llama/llama-3.1-70b-instruct:free** default for Jot, Sorter, Connector, Heartbeat, Architect, Seeker, Librarian, Dev subcommands, the new digest-work-eod and aggregate-week skills

This routing goes in `~/.openclaw/workspace/openclaw.json`. Phase 1 should include a **template** `openclaw.json` in the repo (maybe `Templates/openclaw.json.example`) that the installer copies into place with placeholder API keys. Don't commit real API keys.

### New skills to add

Two new skills for the work-side EOD digest functionality:

**`skills/digest-work-eod.md`** (or `skills/digest-work-eod/SKILL.md` for OpenClaw format):

Reads `vaults/work/06-Daily/*.md` and `vaults/work/07-Dev/PRs/*.md` for dates since the last digest run. Synthesizes a daily digest per missing date. Writes to `vaults/personal/06-Daily/YYYY-MM-DD-work-eod.md`. State tracking via `Meta/last-digest.md`.

Note the two-vault structure: brain-domp currently assumes one vault. The OpenClaw install *expands* this to two vaults (`vaults/work/` and `vaults/personal/`). For local Claude Code installs on the personal laptop, the vault is just the personal one (work vault lives on the other machine). The digest skill only makes sense in the OpenClaw context where both vaults are visible via Syncthing. Skill should detect and no-op if work vault isn't present.

**`skills/aggregate-week.md`**:

Sunday-morning (or `/dev week` manual) skill that reads the past 7 days of `vaults/personal/06-Daily/*-work-eod.md` files and synthesizes a weekly summary to `vaults/personal/06-Daily/YYYY-MM-DD-week-summary.md`. Input for `/dev retro`.

### Updates to agents/dev.md

Add two new subcommands:

- `/dev eod` — manually trigger `digest-work-eod` skill
- `/dev week` — manually trigger `aggregate-week` skill

### Updates to AGENTS.md dispatcher

Add natural-language routing for the new patterns:

| User says | Route to |
|---|---|
| "what did I do today/this week" | Seeker (which now reads digests) |
| "give me the eod" / "summarize today" | Dev → eod subcommand |
| "weekly summary" / "what happened this week" | Dev → week subcommand |

### Updates to architect.md

The Architect agent handles onboarding. Update it to:

- Detect if the install target is OpenClaw (check for `~/.openclaw/workspace/`)
- If yes, generate `SOUL.md` and `HEARTBEAT.md` from the profile data in addition to `Meta/profile.md`
- Ask one new onboarding question for OpenClaw setups: is there a work vault that will be synced in, and if so, what path will it be at (default `vaults/work/`)

### Documentation updates

- `README.md`: Update the agent table (Scribe → Jot), add OpenClaw to platforms, add Dev subcommands (`eod`, `week`), update the vault-structure diagram to show `vaults/work/` and `vaults/personal/` for OpenClaw setups
- `CONTRIBUTING.md`: Update any Scribe references

## Things that are NOT part of Phase 1

Do not touch these — they're downstream:

- Oracle VM provisioning (waiting on Singapore capacity)
- Syncthing setup
- Discord bot creation/config
- OpenClaw daemon setup on the VM
- LaunchAgent/systemd units
- Any deployment scripts beyond what `launchme.sh` already does

## Execution plan — your job

Follow this order:

### Step 1: Audit the current repo state

Before writing anything:

- Read `AGENTS.md`, `CONTRIBUTING.md`, `launchme.sh`, `README.md` fully
- Read every file in `agents/` and `skills/` and `Templates/`
- Grep for "Scribe" case-insensitively — note every occurrence
- Grep for any platform-specific syntax (`@claude`, `@opencode`, MCP references, XML tags that are Claude-specific). Dominic claims the files are platform-agnostic — verify this is actually true and flag anything that isn't.
- Confirm the current branch is `openclaw` and main is untouched

### Step 2: Produce a scaffolding plan

Write a short plan document (call it `PHASE-1-PLAN.md` in the repo root, or just output it in chat) listing:

- Every file that will be modified (with reason)
- Every file that will be added (with reason)
- Every file that will be renamed/moved
- Any open questions or design decisions you encountered that need Dominic's input

**Get Dominic's explicit approval of the plan before writing any code.** If you see something in the repo that contradicts an assumption in this handoff doc, flag it rather than plowing through.

### Step 3: Implement

Work file-by-file, not all-at-once. For each change:

- Make the change
- Run relevant checks (grep for leftover "Scribe", run `launchme.sh --help` if you've changed it, etc.)
- Show Dominic the diff before moving on

Don't commit anything yet. Leave the changes uncommitted so Dominic can review the final state with `git diff` against main.

### Step 4: Test the installer

Create a throwaway directory somewhere (like `/tmp/brain-domp-test/`), run the modified `launchme.sh` against it with each platform flag:

- `launchme.sh --platform claude-code` → verify correct file layout
- `launchme.sh --platform opencode` → verify
- `launchme.sh --platform openclaw` → verify folder-format skills land correctly, SOUL.md generated, HEARTBEAT.md generated
- `launchme.sh --platforms claude-code,openclaw` → verify both platforms get files, symlinks work

If any platform's test fails, fix it and re-test.

### Step 5: Final review

Show Dominic:

- `git status` — what's changed
- `git diff --stat` — summary of the diff
- Full `git diff` if requested
- Any TODOs or known-untested parts (OpenClaw-specific behavior can't be fully tested until the VM is live)

Dominic decides whether to commit and push.

## Hard constraints

- **No commits without explicit approval.** All changes stay in working tree until Dominic says commit.
- **No changes to main.** All work on the `openclaw` branch.
- **No API keys in committed files.** Templates use placeholders like `<YOUR_KEY_HERE>`.
- **Preserve `/clear` / `/exit` hooks on the work side.** Dominic already installed a SessionEnd hook and `/ship-it` slash command on his work laptop pointing to his work vault. Phase 1 doesn't touch those.
- **No `rm -rf` or destructive operations** on Dominic's vault. If the installer needs to clean something, it backs up first.
- **Agent/skill files stay platform-agnostic** in their markdown content. No `@claude` tags, no MCP-specific syntax. Platform differences go in `launchme.sh`, not in the agent prompts.
- **Don't invent features beyond the scope above.** If something seems like it should be improved but isn't in scope, note it as a TODO and move on.

## Useful context about the user

- Dominic is a pragmatic engineer who appreciates directness and pushback when warranted
- Has been building this setup for a week+, is aware of tradeoffs, doesn't need hand-holding on why decisions were made
- Will say "just do it" if he wants you to move faster and "let's pause" if he wants more care
- Values "measure before you cut" — audit the repo state before writing
- Is currently on a 5-day remaining Claude Max window on the personal laptop, so API cost isn't a concern for this session specifically

## Open questions to surface in Step 2

These weren't fully decided in the prior conversation — you should raise them in the scaffolding plan and get Dominic's call before implementing:

1. **Copilot support scope.** Do we attempt real Copilot integration in Phase 1 or stub it? My suggestion: stub with TODO unless the convention is trivially close to what we already do for Claude Code / OpenCode.
2. **`openclaw.json` template contents.** The model routing map from this doc is opinionated. Does the template hard-code it, or leave it empty for the installer to populate during onboarding?
3. **Work-vault presence detection in digest skill.** How does the digest skill decide if the work vault is available? Existence check on the directory? A config flag? Get Dominic's preference.
4. **Backwards compatibility for existing installs.** Someone who already ran `launchme.sh --platform claude-code` before this PR will have `scribe.md` in their config dir. Does `updateme.sh` detect and rename it? Or do we leave a note that re-running `launchme.sh` is required?
5. **Skill file format migration.** If someone previously installed brain-domp on a Claude Code setup and later adds OpenClaw to the same machine, the skills need to exist in both flat-file and folder formats. How does the installer handle that cleanly with symlinks?

## When you're done

Phase 1 is done when:

- All files changed per the scaffolding plan
- Installer tested across all platforms on a throwaway directory
- `git status` is clean except for the intentional changes
- Dominic has reviewed and approved
- Dominic (not you) runs `git add`, `git commit`, `git push origin openclaw`

Then the conversation can end. Phase 2 (Oracle VM setup) happens in a different session.

---

Good luck. Start by reading the repo, not by writing code.
