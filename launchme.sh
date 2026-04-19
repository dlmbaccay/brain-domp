#!/bin/bash

# =============================================================================
# brain-domp — Installer
# =============================================================================
# Usage:
#   bash launchme.sh
#   bash launchme.sh --platform <name>
#   bash launchme.sh --platforms <a,b,c>
#   bash launchme.sh --all
#   bash launchme.sh --copy        (use file copies instead of symlinks)
#
# Supported platforms: claude-code, opencode, gemini-cli, openclaw, copilot
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo "  brain-domp"
echo "  ==============="
echo ""
echo "  Installing into: $VAULT_DIR"
echo ""

# -----------------------------------------------------------------------------
# Parse flags
# -----------------------------------------------------------------------------

PLATFORMS_ARG=""
USE_COPY=false
INSTALL_ALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      PLATFORMS_ARG="$2"
      shift 2
      ;;
    --platforms)
      PLATFORMS_ARG="$2"
      shift 2
      ;;
    --all)
      INSTALL_ALL=true
      shift
      ;;
    --copy)
      USE_COPY=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Platform detection
# -----------------------------------------------------------------------------

detect_platform() {
  local p=""
  [ -d "$HOME/.claude" ] || command -v claude &>/dev/null && p="$p claude-code"
  [ -d "$VAULT_DIR/.opencode" ] || command -v opencode &>/dev/null && p="$p opencode"
  command -v gemini &>/dev/null && p="$p gemini-cli"
  [ -d "$HOME/.openclaw" ] || command -v openclaw &>/dev/null && p="$p openclaw"
  [ -d "$VAULT_DIR/.github" ] || command -v gh &>/dev/null && p="$p copilot"
  echo "$p"
}

if $INSTALL_ALL; then
  PLATFORMS_ARG="$(detect_platform | tr ' ' ',')"
elif [ -z "$PLATFORMS_ARG" ]; then
  # Auto-detect single platform (backward-compat)
  for p in claude-code opencode gemini-cli openclaw copilot; do
    case "$p" in
      claude-code) ( [ -d "$HOME/.claude" ] || command -v claude &>/dev/null ) && PLATFORMS_ARG="claude-code" && break ;;
      opencode)    ( [ -d "$VAULT_DIR/.opencode" ] || command -v opencode &>/dev/null ) && PLATFORMS_ARG="opencode" && break ;;
      gemini-cli)  command -v gemini &>/dev/null && PLATFORMS_ARG="gemini-cli" && break ;;
      openclaw)    ( [ -d "$HOME/.openclaw" ] || command -v openclaw &>/dev/null ) && PLATFORMS_ARG="openclaw" && break ;;
      copilot)     ( [ -d "$VAULT_DIR/.github" ] || command -v gh &>/dev/null ) && PLATFORMS_ARG="copilot" && break ;;
    esac
  done
fi

if [ -z "$PLATFORMS_ARG" ]; then
  echo "  Could not detect your AI coding assistant."
  echo "  Pass it manually: bash launchme.sh --platform [claude-code|opencode|gemini-cli|openclaw|copilot]"
  echo ""
  exit 1
fi

# Normalise to array (strip leading/trailing commas and spaces)
IFS=',' read -ra PLATFORMS <<< "$(echo "$PLATFORMS_ARG" | tr -s ', ' ',')"

# -----------------------------------------------------------------------------
# Helper: install a single file (symlink or copy)
# Copilot skills always use copy (Copilot CLI doesn't follow symlinked directories)
# -----------------------------------------------------------------------------

install_file() {
  local src="$1"
  local dest="$2"
  local force_copy="${3:-false}"

  mkdir -p "$(dirname "$dest")"
  if $USE_COPY || $force_copy; then
    cp -f "$src" "$dest"
  else
    ln -sf "$src" "$dest"
  fi
}

# Helper: install a skill into a folder-per-skill layout (openclaw / copilot)
install_skill_folder() {
  local skill_src="$1"          # e.g. $SCRIPT_DIR/skills/capture-note.md
  local skills_base_dir="$2"    # e.g. ~/.openclaw/workspace/skills
  local force_copy="${3:-false}"
  local name
  name="$(basename "$skill_src" .md)"

  mkdir -p "$skills_base_dir/$name"
  install_file "$skill_src" "$skills_base_dir/$name/SKILL.md" "$force_copy"
  echo "    + $name/SKILL.md"
}

# -----------------------------------------------------------------------------
# install_to_platform — installs brain-domp files for one platform
# -----------------------------------------------------------------------------

install_to_platform() {
  local platform="$1"

  echo "  ── Platform: $platform ──"
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
    *)
      echo "  Unknown platform: $platform"
      echo "  Supported: claude-code, opencode, gemini-cli, openclaw, copilot"
      return 1
      ;;
  esac

  mkdir -p "$AGENTS_DIR"
  mkdir -p "$VAULT_DIR/skills"
  mkdir -p "$VAULT_DIR/Meta"
  mkdir -p "$VAULT_DIR/Templates"

  # -- Agents --
  echo "  Copying agents..."
  for agent in "$SCRIPT_DIR/agents/"*.md; do
    local agent_name
    agent_name="$(basename "$agent" .md)"
    if [ "$platform" = "copilot" ]; then
      install_file "$agent" "$AGENTS_DIR/${agent_name}.agent.md"
    else
      install_file "$agent" "$AGENTS_DIR/${agent_name}.md"
    fi
    echo "    + $(basename "$agent")"
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
  echo "  Copying skills..."
  if [ "$platform" = "openclaw" ]; then
    local skills_dir="$CONFIG_DIR/skills"
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      install_skill_folder "$skill" "$skills_dir"
    done
  elif [ "$platform" = "copilot" ]; then
    local skills_dir="$CONFIG_DIR/skills"
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      install_skill_folder "$skill" "$skills_dir" true  # always copy for Copilot
    done
  else
    # Flat-file install to vault skills/ for claude-code, opencode, gemini-cli
    for skill in "$SCRIPT_DIR/skills/"*.md; do
      install_file "$skill" "$VAULT_DIR/skills/$(basename "$skill")"
      echo "    + $(basename "$skill")"
    done
  fi

  # -- Dispatcher --
  echo ""
  echo "  Installing dispatcher as $(basename "$DISPATCHER_FILE")..."
  # Dispatcher is always a copy — it's the root-level file that the AI reads
  cp "$SCRIPT_DIR/AGENTS.md" "$DISPATCHER_FILE"

  # -- Templates --
  echo ""
  echo "  Copying templates..."
  for template in "$SCRIPT_DIR/Templates/"*.md; do
    local dest="$VAULT_DIR/Templates/$(basename "$template")"
    if [ ! -f "$dest" ]; then
      cp "$template" "$dest"
      echo "    + $(basename "$template")"
    else
      echo "    ~ $(basename "$template") (skipped — already exists)"
    fi
  done

  # -- Meta --
  local MESSAGES_FILE="$VAULT_DIR/Meta/agent-messages.md"
  if [ ! -f "$MESSAGES_FILE" ]; then
    echo ""
    echo "  Initializing Meta/agent-messages.md..."
    cp "$SCRIPT_DIR/Meta/agent-messages.md" "$MESSAGES_FILE"
  fi

  # -- Vault folder structure --
  echo ""
  echo "  Creating vault folder structure..."
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

  # -- OpenClaw-specific extras --
  if [ "$platform" = "openclaw" ]; then
    echo ""
    echo "  Setting up OpenClaw workspace..."

    # SOUL.md stub (Architect overwrites during onboarding)
    if [ ! -f "$CONFIG_DIR/SOUL.md" ]; then
      cp "$SCRIPT_DIR/Templates/SOUL.md" "$CONFIG_DIR/SOUL.md"
      echo "    + SOUL.md (stub — run /architect to personalize)"
    else
      echo "    ~ SOUL.md (skipped — already exists)"
    fi

    # HEARTBEAT.md
    if [ ! -f "$CONFIG_DIR/HEARTBEAT.md" ]; then
      cp "$SCRIPT_DIR/Templates/HEARTBEAT.md" "$CONFIG_DIR/HEARTBEAT.md"
      echo "    + HEARTBEAT.md"
    else
      echo "    ~ HEARTBEAT.md (skipped — already exists)"
    fi

    # openclaw.json (from example template)
    if [ ! -f "$CONFIG_DIR/openclaw.json" ]; then
      cp "$SCRIPT_DIR/Templates/openclaw.json.example" "$CONFIG_DIR/openclaw.json"
      echo "    + openclaw.json (add your API key before use)"
    else
      echo "    ~ openclaw.json (skipped — already exists)"
    fi
  fi

  echo ""
  echo "  ✓ $platform done"
  echo ""
}

# -----------------------------------------------------------------------------
# Run install for each platform
# -----------------------------------------------------------------------------

for platform in "${PLATFORMS[@]}"; do
  platform="$(echo "$platform" | tr -d ' ')"
  [ -z "$platform" ] && continue
  install_to_platform "$platform"
done

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo "  ✓ Installation complete"
echo ""
echo "  Next step:"
echo "  Open your AI coding assistant inside your vault folder and say:"
echo ""
echo "    Initialize my vault"
echo ""
echo "  The Architect agent will walk you through onboarding."
echo ""
