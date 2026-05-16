#!/usr/bin/env bash
#
# Product Development Workflow — Installer
# Installs skills and commands into a Claude Code project or globally.
#
# Usage:
#   ./install.sh                    # Install to current project
#   ./install.sh /path/to/project   # Install to specific project
#   ./install.sh --global           # Install globally (~/.claude/)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
GLOBAL=false
TARGET_DIR=""

for arg in "$@"; do
  case "$arg" in
    --global|-g)
      GLOBAL=true
      ;;
    *)
      TARGET_DIR="$arg"
      ;;
  esac
done

if [ "$GLOBAL" = true ]; then
  # Global installation: install to ~/.claude/
  if [ -n "$HOME" ] && [ -d "$HOME" ]; then
    TARGET_DIR="$HOME"
  elif [ -n "$USERPROFILE" ]; then
    TARGET_DIR="$USERPROFILE"
  else
    echo "Error: Cannot determine home directory"
    exit 1
  fi
  CLAUDE_DIR="$TARGET_DIR/.claude"
  MODE="global"
else
  # Project installation
  TARGET_DIR="${TARGET_DIR:-.}"
  TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "Error: Target directory does not exist: $1"
    exit 1
  }
  CLAUDE_DIR="$TARGET_DIR/.claude"
  MODE="project"
fi

echo "Product Development Workflow Installer"
echo "======================================="
echo "Mode: $MODE"
echo "Target: $CLAUDE_DIR"
echo ""

# Create .claude directory structure
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"

# Install skills
SKILL_COUNT=0
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  dest="$CLAUDE_DIR/skills/$skill_name"
  mkdir -p "$dest"
  cp "$skill_dir"SKILL.md "$dest/SKILL.md"
  SKILL_COUNT=$((SKILL_COUNT + 1))
  echo "  Skill: $skill_name"
done

# Install commands — for global mode, rewrite skill paths to absolute
CMD_COUNT=0
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
  [ -f "$cmd_file" ] || continue
  cmd_name="$(basename "$cmd_file")"

  if [ "$MODE" = "global" ]; then
    # Rewrite relative .claude/skills/ paths to absolute paths
    sed "s|\.claude/skills/|$CLAUDE_DIR/skills/|g" "$cmd_file" > "$CLAUDE_DIR/commands/$cmd_name"
  else
    cp "$cmd_file" "$CLAUDE_DIR/commands/$cmd_name"
  fi

  CMD_COUNT=$((CMD_COUNT + 1))
  echo "  Command: $cmd_name"
done

# Create workflow output directory (project mode only)
if [ "$MODE" = "project" ]; then
  mkdir -p "$TARGET_DIR/docs/workflow"
fi

echo ""
echo "Installed: $SKILL_COUNT skills, $CMD_COUNT commands"
echo ""
if [ "$MODE" = "global" ]; then
  echo "/workflow is now available in ALL projects."
else
  echo "/workflow is available in this project."
fi
echo ""
echo "Usage:"
echo "  /workflow start <your product idea>"
echo "  /workflow status"
echo ""
echo "Done!"
