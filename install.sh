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

# Configure permissions to reduce prompts during workflow execution
SETTINGS_FILE="$CLAUDE_DIR/settings.local.json"
PERMISSIONS='{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Write",
      "Edit",
      "Bash(mkdir *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(find *)",
      "Bash(node *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(yarn *)",
      "Bash(python *)",
      "Bash(git status*)",
      "Bash(git log*)",
      "Bash(git diff*)"
    ]
  }
}'

if [ -f "$SETTINGS_FILE" ]; then
  echo "  Updating existing settings.local.json with workflow permissions..."
  # Merge permissions into existing settings
  if command -v node &>/dev/null; then
    node -e "
      const fs = require('fs');
      const existing = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));
      const perms = $PERMISSIONS;
      existing.permissions = existing.permissions || {};
      existing.permissions.allow = existing.permissions.allow || [];
      const newPerms = perms.permissions.allow.filter(p => !existing.permissions.allow.includes(p));
      existing.permissions.allow = [...existing.permissions.allow, ...newPerms];
      fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(existing, null, 2));
    "
  elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
    PYTHON="python3"; command -v python3 &>/dev/null || PYTHON="python"
    $PYTHON -c "
import json, sys
with open('$SETTINGS_FILE') as f:
    existing = json.load(f)
perms = $PERMISSIONS
existing.setdefault('permissions', {}).setdefault('allow', [])
new_perms = [p for p in perms['permissions']['allow'] if p not in existing['permissions']['allow']]
existing['permissions']['allow'].extend(new_perms)
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(existing, f, indent=2)
"
  else
    echo "  Warning: Could not merge permissions (no node/python). Manual config may be needed."
  fi
else
  echo "  Creating settings.local.json with workflow permissions..."
  echo "$PERMISSIONS" > "$SETTINGS_FILE"
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
