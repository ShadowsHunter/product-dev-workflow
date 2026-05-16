#!/usr/bin/env bash
#
# Product Development Workflow — Installer
# Installs skills and commands into a Claude Code project.
#
# Usage:
#   ./install.sh                    # Install to current directory
#   ./install.sh /path/to/project   # Install to specific project
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve target to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "Error: Target directory does not exist: $1"
  exit 1
}

CLAUDE_DIR="$TARGET_DIR/.claude"

echo "Product Development Workflow Installer"
echo "======================================="
echo "Target: $TARGET_DIR"
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

# Install commands
CMD_COUNT=0
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
  [ -f "$cmd_file" ] || continue
  cp "$cmd_file" "$CLAUDE_DIR/commands/"
  CMD_COUNT=$((CMD_COUNT + 1))
  echo "  Command: $(basename "$cmd_file")"
done

# Create workflow output directory
mkdir -p "$TARGET_DIR/docs/workflow"

echo ""
echo "Installed: $SKILL_COUNT skills, $CMD_COUNT commands"
echo ""
echo "Usage:"
echo "  /workflow start <your product idea>"
echo "  /workflow status"
echo ""
echo "Done!"
