# brain-domp

A crew of 7 AI agents that manage your knowledge vault so your brain doesn't have to.

Built for developers. Works with OpenCode, Claude Code, and Gemini CLI.

---

## What is this?

brain-domp is a set of AI agent definitions and skills that turn a folder of markdown files into an intelligent, self-organizing knowledge system. You talk to it. It captures, files, links, searches, and maintains your notes automatically.

No GUI. No proprietary format. No cloud. Just markdown files and an AI coding assistant you already use.

---

## Agents

| Agent | Trigger | What it does |
|---|---|---|
| **Architect** | first run / `/architect` | Onboards you, creates vault structure, scaffolds projects |
| **Scribe** | `/scribe [input]` | Turns brain dumps into clean structured notes |
| **Sorter** | `/sort` | Empties inbox, files every note to the right place |
| **Seeker** | `/seek [query]` | Searches vault, synthesizes answers with citations |
| **Connector** | `/connect` | Adds wikilinks, builds Maps of Content |
| **Librarian** | `/health` | Weekly vault audit — broken links, orphans, stale notes |
| **Dev** | `/dev [subcommand]` | Standups, PR reviews, ADRs, debug sessions |

### Dev agent subcommands

| Command | What it does |
|---|---|
| `/dev standup` | Logs today's standup |
| `/dev pr [input]` | Creates a PR review note |
| `/dev adr [topic]` | Starts an Architecture Decision Record |
| `/dev debug [problem]` | Opens a debugging session note |
| `/dev retro` | Logs a sprint retrospective |

---

## Vault structure

After running the installer, your vault looks like this:

```
my-vault/
├── brain-domp/            ← this repo (the engine)
├── 00-Inbox/              ← everything lands here first
├── 01-Projects/           ← active work with a deadline
├── 02-Areas/
│   ├── Engineering/
│   │   ├── ADRs/          ← architecture decision records
│   │   ├── API-Design/
│   │   └── Frontend/
│   └── Product/
├── 03-Resources/          ← reference material
├── 04-Archive/            ← completed work
├── 05-People/             ← contacts and colleagues
├── 06-Daily/              ← standups, daily notes
├── 07-Dev/
│   ├── PRs/               ← PR review notes
│   ├── Debug/             ← debugging sessions
│   └── Retros/            ← retrospectives
├── 08-Meetings/           ← meeting notes
├── MOC/                   ← maps of content
├── Templates/             ← note templates
└── Meta/                  ← agent internals, do not edit manually
```

The repo lives inside the vault as a sibling to your notes — not the other way around.

---

## Requirements

- [Obsidian](https://obsidian.md) (free) or any folder of markdown files
- One of:
  - [OpenCode](https://opencode.ai)
  - [Claude Code](https://claude.ai/code)
  - [Gemini CLI](https://github.com/google-gemini/gemini-cli)

---

## Installation

### 1. Create your vault folder

```bash
mkdir my-vault
cd my-vault
```

Or open an existing folder you already use in Obsidian.

### 2. Clone brain-domp into it

```bash
git clone https://github.com/dlmbaccay/brain-domp.git
```

### 3. Run the installer

```bash
cd brain-domp
bash launchme.sh
```

The installer auto-detects your AI coding assistant and copies files to the right place. To specify manually:

```bash
bash launchme.sh --platform opencode
bash launchme.sh --platform claude-code
bash launchme.sh --platform gemini-cli
```

### 4. Initialize your vault

Open your AI coding assistant **inside your vault folder** (not inside brain-domp) and say:

```
Initialize my vault
```

The Architect agent will walk you through a short onboarding — name, stack, role, active projects. Takes about 2 minutes. After that, your vault is ready.

---

## Updating

When new versions are released:

```bash
cd /path/to/my-vault/brain-domp
bash updateme.sh
```

Your vault notes are never touched during updates. Only agent and skill files are updated.

---

## How it works

Every agent is a markdown file with a system prompt. When you trigger an agent, your AI coding assistant reads that file and behaves accordingly. Agents communicate asynchronously through `Meta/agent-messages.md` — a shared message board they all read and write to.

Skills are reusable instruction sets that agents reference by name. If you want to change how notes are formatted across the whole system, you edit one skill file.

```
You → AI assistant → AGENTS.md (dispatcher) → agent file → skill files → your vault
```

Nothing runs in the background. Nothing is scheduled. You are always in control.

---

## Philosophy

> The best organizational system is the one you actually use.

brain-domp was built for developers who are drowning, not for people who enjoy organizing. Every decision prioritizes minimum friction:

- **Chat is the interface** — no manual file management
- **Agents handle the boring parts** — filing, linking, maintaining
- **Your data is yours** — plain markdown, no lock-in, works forever
- **Model agnostic** — switch AI assistants without losing anything
- **Conservative by default** — agents never delete, always archive

---

## License

MIT — use it, modify it, ship it.

