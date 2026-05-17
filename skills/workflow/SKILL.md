---
name: workflow
description: "Orchestrator skill for the product development workflow. Manages 9 phases from topic selection through delivery with human approval gates, state persistence, and parallel execution."
origin: community
---

# Workflow Orchestrator

Coordinate the full product development lifecycle with stage-gated human approval.

## Phase Registry

| Phase ID | Phase Name | Skill Dir | Output File | Depends On | Parallel Group |
|----------|-----------|-----------|-------------|------------|----------------|
| topic-selection | Topic Selection | topic-selection | 01-topic-selection.md | — | — |
| market-research | Market Research | market-research | 02-market-research.md | topic-selection | — |
| product-design | Product Design | product-design | 03-product-design.md | topic-selection, market-research | — |
| prd-writing | PRD Writing | prd-writing | 04-prd.md | product-design | — |
| system-design | System Design | system-design | 05-system-design.md | prd-writing | design |
| ui-ux-design | UI/UX Design | ui-ux-design | 06-ui-ux-design.md | prd-writing | design |
| frontend-dev | Frontend Dev | frontend-dev | (code) | system-design, ui-ux-design | dev |
| backend-dev | Backend Dev | backend-dev | (code) | system-design | dev |
| qa-testing | QA Testing | qa-testing | 07-test-cases.md, 08-test-report.md | frontend-dev, backend-dev | — |
| delivery | Delivery | delivery | 09-delivery-checklist.md | qa-testing | — |

## State Schema

State file: `docs/workflow/workflow-state.json`

```json
{
  "projectName": "string",
  "createdAt": "ISO 8601",
  "updatedAt": "ISO 8601",
  "initialIdea": "string (raw user input)",
  "currentPhase": "phase-id or comma-separated for parallel",
  "phases": [
    {
      "id": "phase-id",
      "name": "Phase Name",
      "status": "pending | in_progress | completed | approved | rejected",
      "output": "docs/workflow/XX-name.md or null",
      "approvedBy": "human | null",
      "approvedAt": "ISO 8601 or null",
      "rejectedAt": "ISO 8601 or null",
      "rejectionReason": "string or null",
      "notes": "string or null"
    }
  ]
}
```

## Scheduling Algorithm

### Phase Transition Rules

```
After topic-selection approved → start market-research
After market-research approved → start product-design
After product-design approved → start prd-writing
After prd-writing approved → start system-design AND ui-ux-design (parallel)
After BOTH system-design AND ui-ux-design approved → start frontend-dev AND backend-dev (parallel)
After BOTH frontend-dev AND backend-dev approved → start qa-testing
After qa-testing approved → start delivery
After delivery approved → WORKFLOW COMPLETE
```

### QA Fix-Retest Loop (Automatic)

The QA phase runs an internal fix-retest loop. The orchestrator drives this loop automatically — the human is NOT consulted between rounds.

```
Round 1:
  1. Spawn QA agent → runs tests → produces test report
  2. Read the test report
  3. Check for P0/P1 bugs:
     IF P0/P1 bugs exist:
       → Spawn fix agents (frontend-dev + backend-dev in parallel)
         with the bug list as context
       → Wait for fixes to complete
       → GOTO Round 2
     ELSE:
       → QA phase complete, produce final report
       → Open approval gate for human

Round N (max 5):
  1. Spawn QA agent again → re-runs ALL tests → updates test report
  2. Check for remaining P0/P1 bugs:
     IF P0/P1 bugs still exist AND round < 5:
       → Spawn fix agents with remaining bug list
       → Wait for fixes
       → GOTO Round N+1
     IF P0/P1 bugs exist AND round >= 5:
       → Produce final report with WARNING
       → Open approval gate — let human decide
     ELSE (no P0/P1 bugs):
       → Produce final report
       → Open approval gate for human
```

Fix agent prompt template (for each round):
```
You are the bug-fix specialist for [project-name].

## Context
The QA tester found the following P0/P1 bugs in Round [N]:

[Paste bug list from test report]

## Your Task
Fix ALL of these bugs. For each bug:
1. Identify the root cause
2. Implement the fix
3. Verify the fix works locally

## Tech Stack
Read .claude/skills/[frontend-dev/backend-dev]/SKILL.md for reference.

## After Fixing
Report what you changed and which bugs were addressed.
```

The QA agent is re-spawned for each round (fresh context with the latest code state). It runs ALL tests, not just the previously failing ones, to catch regressions.

### Human Rejection After QA

When the human rejects the QA phase (for P2/P3 issues or other reasons):
1. Mark qa-testing as `rejected` with the reason
2. Spawn fix agents with the rejection feedback
3. After fixes complete, re-run QA from Round 1
4. The internal fix-retest loop runs again
5. Only open the approval gate when P0/P1 are clear

### Sequential → Parallel Transition

When a phase's next step is a parallel group:
1. Set currentPhase to comma-separated IDs (e.g., "system-design,ui-ux-design")
2. Mark both as `in_progress`
3. Spawn both agents simultaneously via parallel Agent tool calls
4. Wait for both to complete before opening the approval gate

## Agent Prompt Template

For each phase, construct the agent prompt as follows:

```
You are the [phase-name] specialist for the [project-name] project.

## Your Task
Read your execution guide at .claude/skills/[phase-name]/SKILL.md and follow it exactly.

## Project Context
Project: [projectName]
Initial Idea: [initialIdea]

## Input Documents
[For each prior approved phase, list the document path]
- Read: [prior-phase-output-path]

## Output
Write your deliverable to: [output-path from phase registry]

## Process
1. Read your skill file first: .claude/skills/[phase-name]/SKILL.md
2. Read all input documents listed above
3. Execute every step defined in your skill
4. Write your output document using the exact template from the skill
5. Run the self-check list from your skill — verify every item
6. Report completion with a 3-5 bullet point summary of what you produced
```

For development phases (frontend-dev, backend-dev), modify the output section:
```
## Output
You are writing running code. No document output required.
Follow the tech stack and project structure from system-design.
After implementation, verify the application runs and all P0 features work.
```

For qa-testing rejection re-runs, append:
```
## Previous Feedback
The QA tester found these issues:
[paste rejection reason]

Address these issues in your implementation.
```

## Approval Gate Protocol

After a phase agent completes:

1. **Update state**: Mark phase as `completed`, set output path
2. **Display gate message**:

```
═══════════════════════════════════════
  PHASE GATE: [Phase Name]
═══════════════════════════════════════

Output: [output-path]

Summary:
• [Key finding/deliverable 1]
• [Key finding/deliverable 2]
• [Key finding/deliverable 3]

Next: [Next phase name(s)]

Commands:
  /workflow approve              → Accept and proceed
  /workflow reject <feedback>    → Send back for revision
  /workflow status               → Review all phases
═══════════════════════════════════════
```

3. **STOP executing**. Do not proceed to the next phase. Wait for the human.

## Session Recovery

When the user runs `/workflow status` or `/workflow start` (on an existing project):

1. Read `docs/workflow/workflow-state.json`
2. If currentPhase is `complete` → display summary
3. If currentPhase has a `pending` or `in_progress` phase:
   - Read the phase's skill file
   - Read all completed/approved prior phase outputs
   - Determine whether to spawn the agent or wait for approval
4. If a phase is `completed` but not yet `approved`:
   - Re-display the gate message
   - Wait for human action

### Recovery After /clear or Restart

All state is in `docs/workflow/workflow-state.json`. No session-scoped variables are used. The orchestrator reconstructs full context from:
- State file (current phase, phase statuses)
- Skill files (execution guides)
- Output documents (prior phase deliverables)

## Error Handling

### Agent Failure
If a spawned agent fails or times out:
1. Mark the phase as `rejected` with note "Agent execution failed"
2. Display the error to the user
3. Offer to retry: `/workflow redo [phase-id]`

### Corrupted State File
If `workflow-state.json` is unreadable:
1. Scan `docs/workflow/` for existing output files
2. Determine which phases have been completed based on file existence
3. Offer to reconstruct the state file

### Missing Prior Documents
If a required input document doesn't exist:
1. Check if the prior phase was marked `approved` but its output is missing
2. Report to the user and suggest re-running the prior phase
