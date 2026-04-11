#!/bin/bash

# =============================================================================
# brain-domp — Installer
# =============================================================================
# Usage: bash launchme.sh
# Run this from inside your Obsidian vault folder (or any markdown folder).
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(dirname "$SCRIPT_DIR")"
REPO_NAME="$(basename "$SCRIPT_DIR")"

echo ""
echo "  brain-domp"
echo "  ==============="
echo ""
echo "  Installing into: $VAULT_DIR"
echo ""

# -----------------------------------------------------------------------------
# Step 1 — Detect platform
# -----------------------------------------------------------------------------

detect_platform() {
  if [ -d "$VAULT_DIR/.claude" ] || command -v claude &> /dev/null; then
    echo "claude-code"
  elif [ -d "$VAULT_DIR/.opencode" ] || command -v opencode &> /dev/null; then
    echo "opencode"
  elif command -v gemini &> /dev/null; then
    echo "gemini-cli"
  else
    echo "unknown"
  fi
}

PLATFORM=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
if [ -z "$PLATFORM" ]; then
  PLATFORM=$(detect_platform)
fi

echo "  Platform: $PLATFORM"
echo ""

if [ "$PLATFORM" = "unknown" ]; then
  echo "  Could not detect your AI coding assistant."
  echo "  Pass it manually: bash launchme.sh --platform [claude-code|opencode|gemini-cli]"
  echo ""
  exit 1
fi

# -----------------------------------------------------------------------------
# Step 2 — Set config directory and dispatcher filename based on platform
# -----------------------------------------------------------------------------

case "$PLATFORM" in
  claude-code)
    CONFIG_DIR="$VAULT_DIR/.claude"
    DISPATCHER_FILE="$VAULT_DIR/CLAUDE.md"
    AGENTS_DIR="$CONFIG_DIR/agents"
    ;;
  opencode)
    CONFIG_DIR="$VAULT_DIR/.opencode"
    DISPATCHER_FILE="$VAULT_DIR/AGENTS.md"
    AGENTS_DIR="$CONFIG_DIR/agents"
    ;;
  gemini-cli)
    CONFIG_DIR="$VAULT_DIR/.gemini"
    DISPATCHER_FILE="$VAULT_DIR/GEMINI.md"
    AGENTS_DIR="$CONFIG_DIR/agents"
    ;;
esac

# -----------------------------------------------------------------------------
# Step 3 — Create config and agents directories
# -----------------------------------------------------------------------------

mkdir -p "$AGENTS_DIR"
mkdir -p "$VAULT_DIR/skills"
mkdir -p "$VAULT_DIR/Meta"
mkdir -p "$VAULT_DIR/Templates"

# -----------------------------------------------------------------------------
# Step 4 — Copy agent files
# -----------------------------------------------------------------------------

echo "  Copying agents..."
for agent in "$SCRIPT_DIR/agents/"*.md; do
  cp "$agent" "$AGENTS_DIR/"
  echo "    + $(basename $agent)"
done

# -----------------------------------------------------------------------------
# Step 5 — Copy skills
# -----------------------------------------------------------------------------

echo ""
echo "  Copying skills..."
for skill in "$SCRIPT_DIR/skills/"*.md; do
  cp "$skill" "$VAULT_DIR/skills/"
  echo "    + $(basename $skill)"
done

# -----------------------------------------------------------------------------
# Step 6 — Copy dispatcher (platform-specific filename)
# -----------------------------------------------------------------------------

echo ""
echo "  Installing dispatcher as $(basename $DISPATCHER_FILE)..."
cp "$SCRIPT_DIR/AGENTS.md" "$DISPATCHER_FILE"

# -----------------------------------------------------------------------------
# Step 7 — Copy templates (only if Templates/ doesn't already have files)
# -----------------------------------------------------------------------------

echo ""
echo "  Copying templates..."
for template in "$SCRIPT_DIR/Templates/"*.md; do
  dest="$VAULT_DIR/Templates/$(basename $template)"
  if [ ! -f "$dest" ]; then
    cp "$template" "$dest"
    echo "    + $(basename $template)"
  else
    echo "    ~ $(basename $template) (skipped — already exists)"
  fi
done

# -----------------------------------------------------------------------------
# Step 8 — Initialize agent-messages.md if it doesn't exist
# -----------------------------------------------------------------------------

MESSAGES_FILE="$VAULT_DIR/Meta/agent-messages.md"
if [ ! -f "$MESSAGES_FILE" ]; then
  echo ""
  echo "  Initializing Meta/agent-messages.md..."
  cp "$SCRIPT_DIR/Meta/agent-messages.md" "$MESSAGES_FILE"
fi

# -----------------------------------------------------------------------------
# Step 9 — Create .gitkeep files so empty folders survive git
# -----------------------------------------------------------------------------

echo ""
echo "  Creating .gitkeep files for empty folders..."
for dir in \
  "$VAULT_DIR/00-Inbox" \
  "$VAULT_DIR/01-Projects" \
  "$VAULT_DIR/02-Areas/Engineering/ADRs" \
  "$VAULT_DIR/02-Areas/Engineering/API-Design" \
  "$VAULT_DIR/02-Areas/Engineering/Frontend" \
  "$VAULT_DIR/02-Areas/Product" \
  "$VAULT_DIR/03-Resources" \
  "$VAULT_DIR/04-Archive" \
  "$VAULT_DIR/05-People" \
  "$VAULT_DIR/06-Daily" \
  "$VAULT_DIR/07-Dev/PRs" \
  "$VAULT_DIR/07-Dev/Debug" \
  "$VAULT_DIR/07-Dev/Retros" \
  "$VAULT_DIR/08-Meetings" \
  "$VAULT_DIR/MOC"; do
  mkdir -p "$dir"
  touch "$dir/.gitkeep"
done

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo ""
echo "  ✓ Installation complete"
echo ""
echo "  Next step:"
echo "  Open your AI coding assistant inside this vault folder and say:"
echo ""
echo "    Initialize my vault"
echo ""
echo "  The Architect agent will walk you through onboarding."
echo ""

