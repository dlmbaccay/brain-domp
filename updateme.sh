#!/bin/bash

# =============================================================================
# brain-domp — Updater
# =============================================================================
# Usage: bash updateme.sh
# Run this from inside the brain-domp folder after pulling new changes.
# Your vault notes are never touched.
#
# Auto-detects all installed platforms and updates each one.
# Pass --platform <name> to update a specific platform only.
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
# Parse flags
# -----------------------------------------------------------------------------

PLATFORM_FILTER=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      PLATFORM_FILTER="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Pull latest changes
# -----------------------------------------------------------------------------

echo "  Pulling latest changes..."
cd "$SCRIPT_DIR"
git pull
echo ""

# -----------------------------------------------------------------------------
# Detect all installed platforms
# -----------------------------------------------------------------------------

DETECTED_PLATFORMS=()

check_platform() {
  local name="$1"
  local config_dir="$2"
  if [ -d "$config_dir" ]; then
    if [ -n "$PLATFORM_FILTER" ] && [ "$PLATFORM_FILTER" != "$name" ]; then
      return
    fi
    DETECTED_PLATFORMS+=("$name")
    echo "  Detected: $name"
  fi
}

check_platform "claude-code" "$HOME/.claude/agents"
check_platform "opencode"    "$VAULT_DIR/.opencode/agents"
check_platform "gemini-cli"  "$VAULT_DIR/.gemini/agents"
check_platform "openclaw"    "$HOME/.openclaw/workspace/agents"
check_platform "copilot"     "$VAULT_DIR/.github/agents"

if [ ${#DETECTED_PLATFORMS[@]} -eq 0 ]; then
  echo "  No installed platforms found. Run launchme.sh first."
  exit 1
fi

echo ""

# -----------------------------------------------------------------------------
# update_platform — updates one platform
# -----------------------------------------------------------------------------

update_platform() {
  local platform="$1"

  echo "  ── Updating: $platform ──"
  echo ""

  local CONFIG_DIR DISPATCHER_FILE AGENTS_DIR

  case "$platform" in
    claude-code)
      CONFIG_DIR="$HOME/.claude"
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
    openclaw)
      CONFIG_DIR="$HOME/.openclaw/workspace"
      DISPATCHER_FILE="$VAULT_DIR/AGENTS.md"
      AGENTS_DIR="$CONFIG_DIR/agents"
      ;;
    copilot)
      CONFIG_DIR="$VAULT_DIR/.github"
      DISPATCHER_FILE="$VAULT_DIR/AGENTS.md"
      AGENTS_DIR="$CONFIG_DIR/agents"
      ;;
  esac

  # -- Agents --
  echo "  Updating agents..."
  for agent in "$SCRIPT_DIR/agents/"*.md; do
    local agent_name
    agent_name="$(basename "$agent" .md)"
    if [ "$platform" = "copilot" ]; then
      cp "$agent" "$AGENTS_DIR/${agent_name}.agent.md"
    else
      cp "$agent" "$AGENTS_DIR/${agent_name}.md"
    fi
    echo "    ~ $(basename "$agent")"
  done

  # Remove stale scribe.md from agents dir if it exists (renamed to jot)
  if [ -f "$AGENTS_DIR/scribe.md" ] || [ -L "$AGENTS_DIR/scribe.md" ]; then
    rm -f "$AGENTS_DIR/scribe.md"
    echo "    - scribe.md (removed — replaced by jot.md)"
  fi
  if [ -f "$AGENTS_DIR/scribe.agent.md" ] || [ -L "$AGENTS_DIR/scribe.agent.md" ]; then
    rm -f "$AGENTS_DIR/scribe.agent.md"
    echo "    - scribe.agent.md (removed — replaced by jot.agent.md)"
  fi

  # -- Skills --
  echo ""
  echo "  Updating skills..."
  if [ "$platform" = "openclaw" ]; then
    local skills_dir="$CONFIG_DIR/skills"
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      local name
      name="$(basename "$skill" .md)"
      mkdir -p "$skills_dir/$name"
      cp "$skill" "$skills_dir/$name/SKILL.md"
      echo "    ~ $name/SKILL.md"
    done
  elif [ "$platform" = "copilot" ]; then
    local skills_dir="$CONFIG_DIR/skills"
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      local name
      name="$(basename "$skill" .md)"
      mkdir -p "$skills_dir/$name"
      cp "$skill" "$skills_dir/$name/SKILL.md"
      echo "    ~ $name/SKILL.md"
    done
  else
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      cp "$skill" "$VAULT_DIR/skills/"
      echo "    ~ $(basename "$skill")"
    done
  fi

  # -- Dispatcher --
  echo ""
  echo "  Updating dispatcher..."
  cp "$SCRIPT_DIR/AGENTS.md" "$DISPATCHER_FILE"
  echo "    ~ $(basename "$DISPATCHER_FILE")"

  # -- Templates (never overwrite existing) --
  echo ""
  echo "  Checking templates..."
  for template in "$SCRIPT_DIR/Templates/"*.md; do
    local dest="$VAULT_DIR/Templates/$(basename "$template")"
    if [ ! -f "$dest" ]; then
      cp "$template" "$dest"
      echo "    + $(basename "$template") (new)"
    else
      echo "    ~ $(basename "$template") (skipped — your version kept)"
    fi
  done

  echo ""
  echo "  ✓ $platform updated"
  echo ""
}

# -----------------------------------------------------------------------------
# Run update for each detected platform
# -----------------------------------------------------------------------------

for platform in "${DETECTED_PLATFORMS[@]}"; do
  update_platform "$platform"
done

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo "  ✓ Update complete"
echo ""
echo "  Agents and skills updated. Your vault notes were not touched."
echo "  Templates were not overwritten — edit them freely."
echo ""
