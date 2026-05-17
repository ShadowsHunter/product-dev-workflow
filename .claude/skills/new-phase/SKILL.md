---
name: new-phase
description: "Scaffold a new phase skill for the product development workflow. Use when adding a new phase to the workflow pipeline. Accepts the phase name and number as arguments."
origin: community
disable-model-invocation: true
---

# New Phase Scaffolder

Create a new phase skill that integrates with the existing workflow.

## Input

### Arguments
- `$ARGUMENTS` — Phase name and number, e.g. `new-phase 10-iteration "Iteration Planning"`

If only a name is given, auto-number as the next phase after the current highest.

## Execution Steps

1. **Parse arguments** — Extract phase number and name from `$ARGUMENTS`. Derive:
   - `phase-id`: kebab-case version of the name (e.g., "Iteration Planning" → `iteration-planning`)
   - `phase-number`: zero-padded number (e.g., 10 → `10`)
   - `output-file`: `docs/workflow/{phase-number}-{phase-id}.md`

2. **Check for conflicts** — Verify:
   - No existing skill directory at `.claude/skills/{phase-id}/`
   - No existing output file pattern that collides
   - Phase number doesn't duplicate an existing one

3. **Determine insertion point** — Read `.claude/skills/workflow/SKILL.md` and identify:
   - Which phase this new one depends on
   - Whether it runs in parallel with anything
   - What phases depend on it

4. **Create the skill file** — Write `.claude/skills/{phase-id}/SKILL.md` with this structure:

```markdown
---
name: {phase-id}
description: "{one-line description of what this phase accomplishes}. Part of the product development workflow."
origin: community
---

# {Phase Name}

{One-sentence purpose of this phase.}

## Input

### Required
- {List required inputs from upstream phases}

### Optional
- {List optional inputs}

## Execution Steps

1. **{Step name}** — {What to do and why}
2. **{Step name}** — {What to do and why}
   - {Sub-steps if needed}
3. {Continue for each step}

## Output Template

Write to `{output-file}`:

` ` `markdown
# {Phase Name}: [Project Name]

## {Section 1}
{Template content}

## {Section 2}
{Template content}
` ` `

## Self-Check List

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}
- [ ] {Criterion 4}

## Quality Criteria

Good enough when: {practical definition of done}. Not when: {anti-pattern to avoid}.
```

5. **Update the orchestrator** — Edit `.claude/skills/workflow/SKILL.md`:
   - Add the new phase to the Phase Registry table
   - Update the Phase Transition Rules section with new dependency/transition
   - Update the State Schema if new fields are needed

6. **Copy to mirror** — Copy the new SKILL.md to `skills/{phase-id}/SKILL.md` for distribution.

7. **Report** — Print a summary:
   - Created: `.claude/skills/{phase-id}/SKILL.md`
   - Updated: `.claude/skills/workflow/SKILL.md` (phase registry + transition rules)
   - Output file: `{output-file}`
   - Dependencies: {what it depends on}
   - Dependents: {what depends on it}

## Self-Check List

- [ ] Phase ID is kebab-case and doesn't conflict with existing skills
- [ ] SKILL.md has all required sections (Input, Execution Steps, Output Template, Self-Check List)
- [ ] Output file naming follows the `XX-name.md` convention
- [ ] Orchestrator Phase Registry updated with correct row
- [ ] Phase Transition Rules updated with correct dependency chain
- [ ] Mirror copy created in `skills/` directory

## Quality Criteria

Good enough when: the new phase integrates into the workflow without breaking existing phase transitions and a developer could run `/workflow start` and reach the new phase naturally.
