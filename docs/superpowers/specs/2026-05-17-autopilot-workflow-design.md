# Autopilot Workflow Design

Date: 2026-05-17
Status: Approved

## Problem

The current workflow requires manual `/workflow approve` after every phase (up to 10 human interventions) and agents hit permission prompts during execution. This makes the pipeline impractical for unattended runs.

## Solution

Add an `--auto` flag to `/workflow start` that runs the entire 9-phase pipeline without stopping. Agents are spawned with `mode: "bypassPermissions"` to eliminate permission prompts. The existing manual mode is unchanged.

## Design

### 1. Auto-Approve Loop

When `--auto` is active, after each phase agent completes:

1. Run the phase's Self-Check List (already defined in each SKILL.md)
2. Update state: `status: "approved"`, `approvedBy: "auto"`, `approvedAt: <now>`
3. Determine next phase(s) using existing scheduling algorithm
4. Immediately execute next phase — no stop, no gate message

If an agent fails:
- Mark phase as `rejected` with `rejectionReason: "Agent execution failed: <error>"`
- Display the error to the user
- Do NOT cascade to downstream phases
- User can retry with `/workflow redo <phase-id>`

### 2. Permission Elimination

Two layers:

**Agent spawning:** All `Agent()` calls use `mode: "bypassPermissions"`. This removes permission prompts inside spawned agents for file writes, bash commands, npm installs, etc.

**Orchestrator permissions:** Add broad allow patterns to `.claude/settings.json` (team-shared, distributed via install.sh):

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "Agent",
      "Skill(*)",
      "Bash(git *)",
      "Bash(python *)",
      "Bash(node *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(pip *)",
      "Bash(pnpm *)",
      "Bash(yarn *)",
      "Bash(bash *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(cat *)",
      "Bash(ls *)",
      "Bash(test *)"
    ]
  }
}
```

Settings merge strategy during install: merge `permissions.allow` arrays (union), do not overwrite existing entries.

### 3. Progress Reporting

In `--auto` mode, replace gate messages with one-line progress logs:

```
[3/10] Product Design → approved (auto) | Next: PRD Writing
[4/10] PRD Writing → approved (auto) | Next: System Design + UI/UX Design (parallel)
```

On pipeline completion, print a final summary table (same format as `/workflow status`).

Users can check intermediate state at any time via `/workflow status` or by reading `docs/workflow/` output files.

### 4. Command Interface

New flag: `--auto` on the `start` subcommand.

```
/workflow start --auto "my project idea"    # Full autopilot, no stops
/workflow start "my project idea"           # Existing manual mode (unchanged)
/workflow status                             # Works in both modes
/workflow reject <feedback>                  # Manual override (halts auto mode)
/workflow redo <phase-id>                   # Restart a failed phase
```

If a user runs `/workflow reject` during autopilot, the pipeline halts and switches to manual mode for that phase. User can resume auto with `/workflow approve`.

### 5. Files to Modify

| File | Change |
|------|--------|
| `.claude/commands/workflow.md` | Parse `--auto` flag in START subcommand, add auto-pilot protocol, add `mode` to state init |
| `.claude/skills/workflow/SKILL.md` | Add `## Auto-Pilot Protocol` section, update agent spawn template |
| `.claude/settings.json` | Add broad permission allowlist |
| `install.sh` | Copy and merge settings.json, add --auto docs |
| `README.md` | Document `--auto` flag usage |
| `README_EN.md` | Document `--auto` flag usage (English) |

### 6. State File Extension

Add `mode` field to the workflow state:

```json
{
  "projectName": "...",
  "mode": "auto | manual",
  "createdAt": "...",
  ...
}
```

- Set to `"auto"` when started with `--auto`
- Set to `"manual"` by default
- If user runs `/workflow reject` during auto mode, set to `"manual"` (halts auto-advance)
- If user wants to resume auto after manual intervention: `/workflow approve --auto`

### 7. What Does NOT Change

- Phase skills (topic-selection through delivery) — no modifications needed
- QA rejection loop — works identically in auto mode
- Parallel execution — design and dev groups still run in parallel
- Session recovery — same state-file-based recovery mechanism
