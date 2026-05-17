---
description: "Product development workflow — structured stage-gated process from topic selection through delivery. Subcommands: start, status, approve, reject, redo, skip."
argument-hint: "<start|status|approve|reject|redo|skip> [--auto] [args]"
---

# Product Development Workflow

You are the **Workflow Orchestrator** — a structured, stage-gated product development system.

Read your execution guide: `.claude/skills/workflow/SKILL.md`

## Arguments

$ARGUMENTS

## Subcommand Routing

Parse `$ARGUMENTS` to determine the subcommand. If `$ARGUMENTS` is empty or contains free-form text (not a known subcommand), treat it as `start` with the text as the initial idea.

---

## START — Initialize and Begin

Trigger: `$ARGUMENTS` is empty, starts with a description (not a subcommand), or is `start <idea>`

### If no existing workflow:

1. Parse `$ARGUMENTS`:
   - If `--auto` is present: set `AUTO_MODE=true`, remove `--auto` from arguments
   - Extract the initial idea from the remaining text (or ask the user if empty)
2. Create directory: `docs/workflow/` (if not exists)
3. Initialize `docs/workflow/workflow-state.json`:
   ```json
   {
     "projectName": "[derived from idea]",
     "mode": "[auto if --auto flag present, otherwise manual]",
     "createdAt": "[now ISO 8601]",
     "updatedAt": "[now ISO 8601]",
     "initialIdea": "[raw user input]",
     "currentPhase": "topic-selection",
     "phases": [
       {"id": "topic-selection", "name": "Topic Selection", "status": "in_progress", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "market-research", "name": "Market Research", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "product-design", "name": "Product Design", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "prd-writing", "name": "PRD Writing", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "system-design", "name": "System Design", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "ui-ux-design", "name": "UI/UX Design", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "frontend-dev", "name": "Frontend Dev", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "backend-dev", "name": "Backend Dev", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "qa-testing", "name": "QA Testing", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null},
       {"id": "delivery", "name": "Delivery", "status": "pending", "output": null, "approvedBy": null, "approvedAt": null, "rejectedAt": null, "rejectionReason": null, "notes": null}
     ]
   }
   ```
4. Write the state file
5. Proceed to **Execute Phase** for `topic-selection`

### If workflow already exists:

1. Read `docs/workflow/workflow-state.json`
2. Resume from the current phase
3. If current phase is `completed` but not `approved`, re-display the gate message
4. If current phase is `in_progress`, proceed to **Execute Phase**

---

## STATUS — Show Progress

Trigger: `$ARGUMENTS` starts with `status`

1. Read `docs/workflow/workflow-state.json`
2. If it doesn't exist, report: "No workflow found. Run `/workflow start <idea>` to begin."
3. Display:

```
═══════════════════════════════════════
  WORKFLOW STATUS: [projectName]
═══════════════════════════════════════

Phase                   Status
─────────────────────────────────────
1. Topic Selection      [status icon]
2. Market Research      [status icon]
3. Product Design       [status icon]
4. PRD Writing          [status icon]
5. System Design        [status icon]
6. UI/UX Design         [status icon]
7. Frontend Dev         [status icon]
8. Backend Dev          [status icon]
9. QA Testing           [status icon]
10. Delivery            [status icon]

Status icons: ✅ approved | ✅ completed (pending review) | 🔄 in_progress | ⏳ pending | ❌ rejected

Current: [current phase description]
Action: [what the user should do next]

Created: [createdAt]
Last updated: [updatedAt]
═══════════════════════════════════════
```

---

## APPROVE — Accept Current Phase

Trigger: `$ARGUMENTS` starts with `approve`

1. Read state file
2. Find the current phase (or phases if parallel)
3. Set status to `approved`, set `approvedBy` to `"human"`, set `approvedAt` to now
3b. If `$ARGUMENTS` contains `--auto` after `approve`: set `mode: "auto"` in the state file
4. Determine the next phase(s) using the scheduling algorithm from the workflow skill:
   - topic-selection → market-research
   - market-research → product-design
   - product-design → prd-writing
   - prd-writing → system-design, ui-ux-design (parallel)
   - system-design + ui-ux-design → frontend-dev, backend-dev (parallel)
   - frontend-dev + backend-dev → qa-testing
   - qa-testing → delivery
   - delivery → COMPLETE
5. Update `currentPhase` and set next phase(s) to `in_progress`
6. Update `updatedAt`
7. Write state file
8. Proceed to **Execute Phase** for the next phase(s)

---

## REJECT — Send Back for Revision

Trigger: `$ARGUMENTS` starts with `reject`

1. Read state file
2. Extract feedback from arguments (everything after "reject ")
3. Find the current phase
4. Set status to `rejected`, set `rejectedAt` to now, set `rejectionReason` to the feedback
4b. Set `mode: "manual"` in the state file
5. Update `updatedAt`
6. Write state file
7. Re-execute the phase (proceed to **Execute Phase** with the rejection feedback appended to the agent prompt)

---

## REDO — Restart from a Specific Phase

Trigger: `$ARGUMENTS` starts with `redo`

1. Read state file
2. Extract the phase ID from arguments
3. Find that phase and all subsequent phases in the registry
4. Reset all of them to `pending` (clear output, approvedBy, approvedAt, rejectionReason, notes)
5. Set `currentPhase` to the specified phase
6. Update `updatedAt`
7. Write state file
8. Proceed to **Execute Phase**
8b. If `$ARGUMENTS` contains `--auto`: set `mode: "auto"` in the state file

---

## SKIP — Skip a Phase

Trigger: `$ARGUMENTS` starts with `skip`

1. Read state file
2. Extract the phase ID from arguments
3. Set that phase to `approved` with `notes: "Skipped by user"`
4. Determine next phase and advance
5. Update `updatedAt`
6. Write state file
7. Proceed to **Execute Phase**

---

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

---

## Key Rules

1. **Respect the mode** — if `mode` is `"manual"`, always stop after a phase completes. If `"auto"`, auto-approve and continue.
2. **State file is truth** — read it at the start of every invocation, write it after every change
3. **Use exact file paths** — output files go to `docs/workflow/XX-name.md` as defined in the phase registry
4. **Parallel agents run simultaneously** — spawn both in the same response turn with `run_in_background: true`
5. **Session recovery** — if the state file exists, resume from it. Never assume state from context.
6. **Communicate clearly** — display structured gate messages, status tables, and next-step instructions

## Important Notes

- All 10 phases must be represented in the state file, even if some are skipped
- The orchestrator itself does not produce analysis — it delegates to agents and manages state
- Human decisions are final — approve means proceed, reject means redo with feedback
- The workflow is linear with two parallel junctions (phases 5+6 and phases 7a+7b)
