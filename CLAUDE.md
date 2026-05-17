# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin that adds a 9-phase product development workflow. Each phase is a skill under `.claude/skills/<phase-name>/SKILL.md`. The orchestrator (`workflow` skill) manages phase transitions, state persistence, and parallel execution.

## Skill File Conventions

Every SKILL.md must have:
- YAML frontmatter with `name`, `description`, and `origin: community`
- Sections: `## Input`, `## Execution Steps`, `## Output Template`, `## Self-Check List`
- Quality Criteria section as a one-liner defining "good enough"

Output files go to `docs/workflow/XX-phase-name.md` where `XX` is the zero-padded phase number. Development phases (frontend-dev, backend-dev) write code, not documents.

## State Persistence

Workflow state lives in `docs/workflow/workflow-state.json`. This file survives session restarts and `/clear`. Phases have statuses: `pending → in_progress → completed → approved | rejected`.

## Parallel Execution

Two parallel groups exist:
- **Design group**: system-design + ui-ux-design (after PRD approval)
- **Dev group**: frontend-dev + backend-dev (after both design phases approved)

Both phases in a group must be approved before downstream phases start.

## QA Rejection Loop

When QA is rejected, both frontend-dev and backend-dev reset to `pending` and re-execute with the rejection feedback.

## Autopilot Mode

`/workflow start --auto <idea>` runs the entire pipeline without stopping. Agents are spawned with `mode: "bypassPermissions"`. State file tracks `mode: "auto|manual"`. Use `/workflow reject` to pause auto, `/workflow approve --auto` to resume.

## Install Script

`install.sh` handles setup. Supports `--global` (installs to `~/.claude/`) or project-local install. The `skills/` directory at repo root is a mirror of `.claude/skills/` used for distribution.

## Windows Paths

The install script handles Windows paths via MSYS/Git Bash. Use forward slashes in all path references within skill files.

## Environment

- `python3` is a Windows Store stub; use `python` instead
- GitHub CLI is at `/c/Program Files/GitHub CLI/gh.exe` — add to PATH if needed: `export PATH="/c/Program Files/GitHub CLI:$PATH"`
- `jq` is not installed; use `python -c "import json; ..."` for JSON processing
