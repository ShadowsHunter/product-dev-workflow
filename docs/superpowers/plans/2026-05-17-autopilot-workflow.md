# Autopilot Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `--auto` flag to `/workflow start` that runs the full 9-phase pipeline without stopping, and eliminate permission prompts during execution.

**Architecture:** The orchestrator command (workflow.md) gains an `--auto` mode that auto-approves after each phase instead of halting. Agents are spawned with `mode: "bypassPermissions"`. The workflow skill (SKILL.md) gets an Auto-Pilot Protocol section. Settings are broadened to cover common dev operations.

**Tech Stack:** Markdown (Claude Code skills/commands), JSON (settings), Bash (install script)

---

## File Structure

| File | Responsibility |
|------|---------------|
| `.claude/settings.json` | Permissions allowlist + frontmatter hook (existing) |
| `.claude/skills/workflow/SKILL.md` | Orchestrator skill with auto-pilot protocol |
| `.claude/commands/workflow.md` | Command entry point with `--auto` parsing |
| `install.sh` | Install script with settings.json merge |
| `README.md` | Chinese docs |
| `README_EN.md` | English docs |

---

### Task 1: Update settings.json with broad permissions

**Files:**
- Modify: `.claude/settings.json`

- [ ] **Step 1: Write the updated settings.json**

Replace the entire file. The frontmatter hook stays; add the `permissions.allow` block from the spec.

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
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "python -c \"import sys,json,re\ndata=json.load(sys.stdin)\nfp=data.get('tool_input',{}).get('file_path','')\nif not fp.endswith('SKILL.md'):sys.exit(0)\ntry:\n f=open(fp,'r',encoding='utf-8');c=f.read();f.close()\nexcept:sys.exit(0)\nif not c.startswith('---'):print(json.dumps({'systemMessage':'SKILL.md missing YAML frontmatter block'}));sys.exit(0)\nm=re.match(r'^---\\n(.*?)\\n---',c,re.DOTALL)\nif not m:print(json.dumps({'systemMessage':'SKILL.md has malformed YAML frontmatter'}));sys.exit(0)\nfm=m.group(1)\nmissing=[x.rstrip(':') for x in ['name:','description:','origin:'] if x not in fm]\nif missing:print(json.dumps({'systemMessage':'SKILL.md frontmatter missing: '+', '.join(missing)}))\" 2>/dev/null || true",
            "timeout": 15,
            "statusMessage": "Validating SKILL.md frontmatter..."
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Validate JSON**

Run: `python -c "import json; json.load(open('.claude/settings.json')); print('OK')"`
Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add .claude/settings.json
git commit -m "feat: add broad permission allowlist for autopilot mode"
```

---

### Task 2: Add Auto-Pilot Protocol to workflow SKILL.md

**Files:**
- Modify: `.claude/skills/workflow/SKILL.md`

- [ ] **Step 1: Add Auto-Pilot Protocol section**

Insert a new section `## Auto-Pilot Protocol` after the existing `## Approval Gate Protocol` section (after line 159). Also update the Agent Prompt Template to use `bypassPermissions`.

**Insert after the Approval Gate Protocol section (after the `3. **STOP executing**...` line):**

```markdown
## Auto-Pilot Protocol

When `mode` is `"auto"` in the workflow state:

1. After a phase agent completes, do NOT display the gate message or stop
2. Update state: `status: "approved"`, `approvedBy: "auto"`, `approvedAt: <now>`
3. Print a one-line progress log:
   ```
   [N/10] Phase Name → approved (auto) | Next: [next phase names]
   ```
4. Immediately proceed to the next phase using the scheduling algorithm
5. If both phases in a parallel group complete, print progress for both before advancing

### Auto-Pilot Error Handling

If a phase agent fails:
1. Mark phase as `rejected` with `rejectionReason: "Agent execution failed: <error>"`
2. Print: `[N/10] Phase Name → FAILED: <error summary>`
3. Set `mode: "manual"` in the state file
4. STOP the pipeline — do not cascade the failure
5. User can retry with `/workflow redo <phase-id>` or `/workflow redo <phase-id> --auto`

### Mode Transitions

- `--auto` flag on `/workflow start` → set `mode: "auto"`
- Agent failure during auto → set `mode: "manual"`
- `/workflow reject` during auto → set `mode: "manual"`, halt auto-advance
- `/workflow approve --auto` → set `mode: "auto"`, resume auto-advance

### Completion

When the last phase (delivery) is approved in auto mode:
1. Print a final summary table using the `/workflow status` format
2. Print: `Pipeline complete. All 10 phases approved.`
3. Set `currentPhase: "complete"`
```

- [ ] **Step 2: Update the Agent Prompt Template to use bypassPermissions**

In the `## Agent Prompt Template` section, find the agent spawn example (the code block with `Agent({`). Replace `mode: "auto"` with `mode: "bypassPermissions"` in all three spawn examples (sequential, parallel, and background).

Change:
```
   Agent({
     subagent_type: "general-purpose",
     prompt: "[constructed prompt]",
     mode: "auto"
   })
```
To:
```
   Agent({
     subagent_type: "general-purpose",
     prompt: "[constructed prompt]",
     mode: "bypassPermissions"
   })
```

And the parallel spawn:
```
     Agent({ subagent_type: "general-purpose", prompt: "[agent-1-prompt]", mode: "auto", run_in_background: true })
```
To:
```
     Agent({ subagent_type: "general-purpose", prompt: "[agent-1-prompt]", mode: "bypassPermissions", run_in_background: true })
```

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/workflow/SKILL.md
git commit -m "feat: add auto-pilot protocol to workflow skill"
```

---

### Task 3: Update workflow command with --auto flag

**Files:**
- Modify: `.claude/commands/workflow.md`

- [ ] **Step 1: Update argument-hint and description in frontmatter**

Change:
```yaml
argument-hint: "<start|status|approve|reject|redo|skip> [args]"
```
To:
```yaml
argument-hint: "<start|status|approve|reject|redo|skip> [--auto] [args]"
```

- [ ] **Step 2: Add --auto flag parsing to START section**

In the `## START — Initialize and Begin` section, after `Extract the initial idea from $ARGUMENTS`, add auto flag detection. Update the state initialization JSON to include the `mode` field.

In the `### If no existing workflow:` subsection, change step 1 to:

```markdown
1. Parse `$ARGUMENTS`:
   - If `--auto` is present: set `AUTO_MODE=true`, remove `--auto` from arguments
   - Extract the initial idea from the remaining text (or ask the user if empty)
```

Change step 3 (state initialization) to include `mode`:

```json
   {
     "projectName": "[derived from idea]",
     "mode": "auto",
     "createdAt": "[now ISO 8601]",
     ...
   }
```

Where `mode` is `"auto"` if `--auto` was present, otherwise `"manual"`.

- [ ] **Step 3: Add --auto flag parsing to APPROVE section**

In the `## APPROVE — Accept Current Phase` section, add detection for `--auto` on approve:

After step 3 (`Set status to "approved"...`), add:

```markdown
3b. If `$ARGUMENTS` contains `--auto` after `approve`: set `mode: "auto"` in the state file
```

- [ ] **Step 4: Add --auto flag parsing to REJECT section**

In the `## REJECT — Send Back for Revision` section, after step 4 (`Set status to "rejected"...`), add:

```markdown
4b. Set `mode: "manual"` in the state file
```

- [ ] **Step 5: Add --auto flag parsing to REDO section**

In the `## REDO — Restart from a Specific Phase` section, add `--auto` detection:

After step 8 (`Proceed to Execute Phase`), add:

```markdown
8b. If `$ARGUMENTS` contains `--auto`: set `mode: "auto"` in the state file
```

- [ ] **Step 6: Replace the Execute Phase section with auto-aware version**

Replace the entire `## Execute Phase` section with the following. This adds the auto-pilot loop while preserving all existing sequential/parallel/dev/QA behavior.

```markdown
## Execute Phase

This is the core orchestration loop, called by all subcommands that advance the workflow.

### Sequential Phase (single phase):

1. Read the workflow skill: `.claude/skills/workflow/SKILL.md`
2. Read the phase skill: `.claude/skills/[phase-id]/SKILL.md`
3. Read all input documents (prior approved phase outputs)
4. Construct the agent prompt using the template from the workflow skill
5. Spawn a **general-purpose** Agent:
   ```
   Agent({
     subagent_type: "general-purpose",
     prompt: "[constructed prompt]",
     mode: "bypassPermissions"
   })
   ```
6. Wait for the agent to complete
7. Verify the output file exists (for document-producing phases)
8. Update state: mark phase as `completed`, set output path
9. **Check mode**:
   - If `mode` is `"auto"`: auto-approve and continue (see Auto-Pilot Protocol in workflow skill)
   - If `mode` is `"manual"`: display the **Phase Gate** message and **STOP** — wait for human

### Parallel Phases (two agents simultaneously):

1. Read both phase skills
2. Read all input documents for both
3. Construct prompts for both agents
4. Spawn **two agents in parallel** (both in the same response turn):
   ```
   Agent({ subagent_type: "general-purpose", prompt: "[agent-1-prompt]", mode: "bypassPermissions", run_in_background: true })
   Agent({ subagent_type: "general-purpose", prompt: "[agent-2-prompt]", mode: "bypassPermissions", run_in_background: true })
   ```
5. Wait for both to complete
6. Update state: mark both phases as `completed`
7. **Check mode**:
   - If `mode` is `"auto"`: auto-approve both and continue
   - If `mode` is `"manual"`: display the **Phase Gate** message for the parallel group and **STOP**

### Development Phases (code output, no document):

For `frontend-dev` and `backend-dev`, the agents write running code instead of documents.
- Verify the code runs (check for build errors)
- No output file path in state

### QA Testing with Prior Rejection:

If `qa-testing` was previously rejected and is being re-run:
- The scheduling algorithm resets `frontend-dev` and `backend-dev` to pending
- Both are re-spawned with the rejection feedback
- After both complete, QA testing runs again
```

- [ ] **Step 7: Update Key Rules section**

In the `## Key Rules` section, change rule 1 from:

```markdown
1. **Never skip the approval gate** — always stop after a phase completes and wait for human input
```
To:
```markdown
1. **Respect the mode** — if `mode` is `"manual"`, always stop after a phase completes. If `"auto"`, auto-approve and continue.
```

- [ ] **Step 8: Commit**

```bash
git add .claude/commands/workflow.md
git commit -m "feat: add --auto flag and auto-pilot execution to workflow command"
```

---

### Task 4: Update install.sh to copy and merge settings.json

**Files:**
- Modify: `install.sh`

- [ ] **Step 1: Add settings.json copy/merge after the permissions block**

After the existing permissions configuration block (after the `PERM_EOF` / `fi` block around line 171), and before the final `echo ""` / summary block (line 173), insert a new section that copies `.claude/settings.json` and merges it:

```bash
# Copy and merge settings.json (hooks, permissions)
SHARED_SETTINGS="$CLAUDE_DIR/settings.json"
SOURCE_SETTINGS="$SCRIPT_DIR/.claude/settings.json"

if [ -f "$SOURCE_SETTINGS" ]; then
  SETTINGS_NATIVE="$SHARED_SETTINGS"
  if command -v cygpath &>/dev/null; then
    SETTINGS_NATIVE="$(cygpath -w "$SHARED_SETTINGS")"
  fi

  if [ -f "$SHARED_SETTINGS" ]; then
    echo "  Merging shared settings.json..."
    if command -v node &>/dev/null; then
      TARGET_SETTINGS="$SETTINGS_NATIVE" SOURCE_SETTINGS_NATIVE="$(if command -v cygpath &>/dev/null; then cygpath -w "$SOURCE_SETTINGS"; else echo "$SOURCE_SETTINGS"; fi)" node -e "
        const fs = require('fs');
        const target = JSON.parse(fs.readFileSync(process.env.TARGET_SETTINGS, 'utf8'));
        const source = JSON.parse(fs.readFileSync(process.env.SOURCE_SETTINGS_NATIVE, 'utf8'));
        // Merge permissions.allow (union)
        if (source.permissions && source.permissions.allow) {
          target.permissions = target.permissions || {};
          target.permissions.allow = target.permissions.allow || [];
          const merged = [...new Set([...target.permissions.allow, ...source.permissions.allow])];
          target.permissions.allow = merged;
        }
        // Merge hooks (source overrides target for same event+matcher)
        if (source.hooks) {
          target.hooks = target.hooks || {};
          for (const [event, hooks] of Object.entries(source.hooks)) {
            target.hooks[event] = hooks; // source takes precedence
          }
        }
        fs.writeFileSync(process.env.TARGET_SETTINGS, JSON.stringify(target, null, 2));
      "
    elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
      PYTHON="python3"; command -v python3 &>/dev/null || PYTHON="python"
      SOURCE_NATIVE="$(if command -v cygpath &>/dev/null; then cygpath -w "$SOURCE_SETTINGS"; else echo "$SOURCE_SETTINGS"; fi)"
      TARGET_SETTINGS="$SETTINGS_NATIVE" SOURCE_SETTINGS_NATIVE="$SOURCE_NATIVE" $PYTHON -c "
import json, os
target_path = os.environ['TARGET_SETTINGS']
source_path = os.environ['SOURCE_SETTINGS_NATIVE']
with open(target_path) as f: target = json.load(f)
with open(source_path) as f: source = json.load(f)
if 'permissions' in source and 'allow' in source['permissions']:
    target.setdefault('permissions', {}).setdefault('allow', [])
    merged = list(dict.fromkeys(target['permissions']['allow'] + source['permissions']['allow']))
    target['permissions']['allow'] = merged
if 'hooks' in source:
    target.setdefault('hooks', {})
    for event, hooks in source['hooks'].items():
        target['hooks'][event] = hooks
with open(target_path, 'w') as f: json.dump(target, f, indent=2)
"
    else
      echo "  Warning: Could not merge settings.json (no node/python). Copying source directly."
      cp "$SOURCE_SETTINGS" "$SHARED_SETTINGS"
    fi
  else
    echo "  Creating shared settings.json..."
    cp "$SOURCE_SETTINGS" "$SHARED_SETTINGS"
  fi
  echo "  Settings: merged"
fi
```

- [ ] **Step 2: Update the usage echo to include --auto**

Change the usage echo block at the end of the script from:

```bash
echo "Usage:"
echo "  /workflow start <your product idea>"
echo "  /workflow status"
```
To:
```bash
echo "Usage:"
echo "  /workflow start <your product idea>         # Manual mode (approve each phase)"
echo "  /workflow start --auto <your product idea>  # Autopilot (runs end-to-end)"
echo "  /workflow status"
```

- [ ] **Step 3: Commit**

```bash
git add install.sh
git commit -m "feat: install script copies and merges settings.json"
```

---

### Task 5: Update README.md (Chinese)

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update 概述 section to mention autopilot**

Change:
```markdown
- **人类决策** 每个阶段完成后暂停，等待人工审批
```
To:
```markdown
- **人类决策** 每个阶段完成后暂停，等待人工审批（支持 `--auto` 全自动模式）
```

- [ ] **Step 2: Add autopilot usage to 使用方法 section**

After the existing `# 启动新的产品工作流` example block, add:

```markdown
# 启动全自动工作流（无需人工审批）
/workflow start --auto 做一个面向自由职业者的记账App

# 全自动运行中暂停（切换到手动模式）
/workflow reject 需要调整产品设计方向

# 恢复全自动运行
/workflow approve --auto
```

- [ ] **Step 3: Update 工作原理 section**

Change step 3:
```markdown
3. 阶段完成后，编排器暂停并展示审批门控
```
To:
```markdown
3. 阶段完成后，编排器暂停并展示审批门控（`--auto` 模式下自动通过并继续）
```

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: add --auto flag documentation (Chinese)"
```

---

### Task 6: Update README_EN.md (English)

**Files:**
- Modify: `README_EN.md`

- [ ] **Step 1: Update Overview section to mention autopilot**

Change:
```markdown
- **Humans** make decisions and approve at every stage gate
```
To:
```markdown
- **Humans** make decisions and approve at every stage gate (or use `--auto` for unattended runs)
```

- [ ] **Step 2: Add autopilot usage to Usage section**

After the existing `# Start a new product workflow` example block, add:

```markdown
# Start in autopilot mode (no approval gates)
/workflow start --auto Build a bookkeeping app for freelancers

# Pause autopilot (switch to manual mode)
/workflow reject Need to adjust the product design direction

# Resume autopilot
/workflow approve --auto
```

- [ ] **Step 3: Update How It Works section**

Change step 3:
```markdown
3. After each phase, the orchestrator pauses for human approval
```
To:
```markdown
3. After each phase, the orchestrator pauses for human approval (in `--auto` mode, phases are auto-approved)
```

- [ ] **Step 4: Commit**

```bash
git add README_EN.md
git commit -m "docs: add --auto flag documentation (English)"
```

---

### Task 7: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Add autopilot note to the State Persistence section**

After the existing State Persistence section, add:

```markdown
## Autopilot Mode

`/workflow start --auto <idea>` runs the entire pipeline without stopping. Agents are spawned with `mode: "bypassPermissions"`. State file tracks `mode: "auto|manual"`. Use `/workflow reject` to pause auto, `/workflow approve --auto` to resume.
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add autopilot mode to CLAUDE.md"
```

---

### Task 8: Mirror changes to skills/ directory

**Files:**
- Modify: `skills/workflow/SKILL.md`

- [ ] **Step 1: Copy updated workflow skill to mirror**

```bash
cp .claude/skills/workflow/SKILL.md skills/workflow/SKILL.md
```

- [ ] **Step 2: Commit**

```bash
git add skills/workflow/SKILL.md
git commit -m "chore: sync workflow skill to mirror directory"
```
