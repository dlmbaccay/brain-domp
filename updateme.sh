#!/bin/bash

# =============================================================================
# brain-domp — Updater
# =============================================================================
# Usage: bash updateme.sh
# Run this from inside the brain-domp folder after pulling new changes.
# Your vault notes are never touched.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo "  brain-domp — Updater"
echo "  ========================="
echo ""
echo "  Vault: $VAULT_DIR"
echo ""

# -----------------------------------------------------------------------------
# Step 1 — Pull latest changes
# -----------------------------------------------------------------------------

echo "  Pulling latest changes..."
cd "$SCRIPT_DIR"
git pull
echo ""

# -----------------------------------------------------------------------------
# Step 2 — Detect platform from existing install
# -----------------------------------------------------------------------------

if [ -d "$VAULT_DIR/.claude" ]; then
  PLATFORM="claude-code"
  CONFIG_DIR="$VAULT_DIR/.claude"
  DISPATCHER_FILE="$VAULT_DIR/CLAUDE.md"
elif [ -d "$VAULT_DIR/.opencode" ]; then
  PLATFORM="opencode"
  CONFIG_DIR="$VAULT_DIR/.opencode"
  DISPATCHER_FILE="$VAULT_DIR/AGENTS.md"
elif [ -d "$VAULT_DIR/.gemini" ]; then
  PLATFORM="gemini-cli"
  CONFIG_DIR="$VAULT_DIR/.gemini"
  DISPATCHER_FILE="$VAULT_DIR/GEMINI.md"
else
  echo "  Could not detect platform. Run launchme.sh first."
  exit 1
fi

AGENTS_DIR="$CONFIG_DIR/agents"

echo "  Detected platform: $PLATFORM"
echo ""

# -----------------------------------------------------------------------------
# Step 3 — Update agent files
# -----------------------------------------------------------------------------

echo "  Updating agents..."
for agent in "$SCRIPT_DIR/agents/"*.md; do
  cp "$agent" "$AGENTS_DIR/"
  echo "    ~ $(basename $agent)"
done

# -----------------------------------------------------------------------------
# Step 4 — Update skills
# -----------------------------------------------------------------------------

echo ""
echo "  Updating skills..."
for skill in "$SCRIPT_DIR/skills/"*.md; do
  cp "$skill" "$VAULT_DIR/skills/"
  echo "    ~ $(basename $skill)"
done

# -----------------------------------------------------------------------------
# Step 5 — Update dispatcher
# -----------------------------------------------------------------------------

echo ""
echo "  Updating dispatcher..."
cp "$SCRIPT_DIR/AGENTS.md" "$DISPATCHER_FILE"
echo "    ~ $(basename $DISPATCHER_FILE)"

# -----------------------------------------------------------------------------
# Step 6 — Update templates (never overwrite existing)
# -----------------------------------------------------------------------------

echo ""
echo "  Checking templates..."
for template in "$SCRIPT_DIR/Templates/"*.md; do
  dest="$VAULT_DIR/Templates/$(basename $template)"
  if [ ! -f "$dest" ]; then
    cp "$template" "$dest"
    echo "    + $(basename $template) (new)"
  else
    echo "    ~ $(basename $template) (skipped — your version kept)"
  fi
done

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo ""
echo "  ✓ Update complete"
echo ""
echo "  Agents and skills updated. Your vault notes were not touched."
echo "  Templates were not overwritten — edit them freely."
echo ""

