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

### QA Rejection Loop

When qa-testing is rejected:
1. Mark qa-testing as `rejected` with the reason
2. Reset both frontend-dev and backend-dev to `pending`
3. Set currentPhase to `frontend-dev,backend-dev`
4. Re-spawn both agents with the rejection feedback appended to their context

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
