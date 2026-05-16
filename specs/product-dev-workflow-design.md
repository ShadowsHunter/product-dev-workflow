# Product Development Workflow Design

> AI-driven product development workflow for Claude Code, combining Skill knowledge layer with Agent execution layer.

## Overview

A structured, stage-gated product development workflow where:

- **Orchestrator Agent** acts as global controller: task dispatch, state management, approval gating
- **Stage Skills** define domain knowledge: execution logic, document templates, quality checklists
- **Execution Agents** are spawned per stage, load the corresponding Skill, and execute
- **Humans** make decisions and approve at every stage gate

Target: software products (Web apps, SaaS, mobile apps).

---

## Architecture

### Layer Structure

```
Orchestrator Agent (global controller)
├── Holds workflow-state.json
├── Manages phase transitions
├── Approval gates (pauses for human)
│
├── topic-selector Agent       (loads topic-selection skill)
├── market-researcher Agent    (loads market-research skill)
├── product-designer Agent     (loads product-design skill)
├── prd-writer Agent           (loads prd-writing skill)
├── system-architect Agent     (loads system-design skill)
├── ui-ux-designer Agent       (loads ui-ux-design skill)
├── frontend-dev Agent         (loads frontend-dev skill)    ┐ parallel
├── backend-dev Agent          (loads backend-dev skill)     ┘
├── qa-tester Agent            (loads qa-testing skill)
└── deliverer Agent            (loads delivery skill)
```

### Communication

| Direction | Mechanism | Purpose |
|-----------|-----------|---------|
| Orchestrator → Stage Agent | `SendMessage` | Assign task, pass context (document paths from prior stages) |
| Stage Agent → Orchestrator | `TaskUpdate` + `SendMessage` | Mark completion, notify results |
| Stage Agent ↔ Stage Agent | `SendMessage` | Cross-stage queries (e.g., `frontend-dev` asks `system-architect` about API details) |
| Human ↔ Orchestrator | Approval gate | Review output, approve/reject with feedback |

### Skill vs Agent

- **Skill** = knowledge: input template, execution guide, output template, self-check list
- **Agent** = executor: spawned by Orchestrator, loads Skill, executes, reports back
- Same Skill reusable across projects

---

## Phases

### Phase 1: Topic Selection (topic-selector)

**Input:**
- Mode A: User's initial idea (text description)
- Mode B: User's interest domain / skill direction

**Execution:**
- Mode A: Validate feasibility (market size, competition, technical feasibility)
- Mode B: Scan trends (GitHub Trending, Product Hunt, industry reports), recommend topics

**Output:** `docs/workflow/01-topic-selection.md`
- Topic name and one-line description
- Problem/opportunity statement
- Target user profile summary
- Preliminary feasibility assessment (high/medium/low)
- Reason for recommending to proceed

**Gate:** Human confirms topic → proceed to market research

---

### Phase 2: Market Research (market-researcher)

**Input:** Topic selection report

**Execution:**
- Competitive analysis (3-5 direct + indirect competitors)
- Market size estimation (TAM/SAM/SOM)
- User persona refinement
- Differentiation positioning analysis

**Output:** `docs/workflow/02-market-research.md`
- Competitor comparison table
- Market size data
- User personas (2-3 typical users)
- Differentiation strategy
- Risk assessment

**Gate:** Human confirms research conclusions → proceed to product design

---

### Phase 3: Product Design (product-designer)

**Input:** Topic selection report + market research report

**Execution:**
- Define core features and priority (P0/P1/P2)
- Write user stories
- Information architecture design
- User flow diagrams

**Output:** `docs/workflow/03-product-design.md`
- Feature list (sorted by priority)
- User stories (Epic → Story)
- Information architecture diagram
- Core user flows

**Gate:** Human confirms product direction → proceed to PRD

---

### Phase 4: PRD (prd-writer)

**Input:** Topic selection report + market research report + product design document

**Execution:**
- Detailed feature requirement descriptions
- Acceptance criteria (per feature)
- Non-functional requirements
- Data model overview

**Output:** `docs/workflow/04-prd.md`
- Feature requirements (description, input/output, acceptance criteria per feature)
- Non-functional requirements (performance, security, usability)
- Data model
- Dependencies and constraints
- MVP scope definition

**Gate:** Human confirms PRD → proceed to system design + UI UX design (both can start in parallel)

---

### Phase 5: System Boundary Design (system-architect)

**Input:** PRD document

**Execution:**
- Tech stack selection (frontend framework, backend framework, database, deployment)
- API contract design (OpenAPI format)
- System architecture diagram
- Database schema design
- Third-party service integration plan

**Output:** `docs/workflow/05-system-design.md`
- Tech stack choices with rationale
- System architecture diagram
- API contract (endpoints, request/response formats)
- Database schema
- Deployment architecture

**Gate:** Human confirms technical plan → proceed to development

---

### Phase 6: UI UX Design (ui-ux-designer)

**Input:** PRD document + product design document

**Execution:**
- Interaction design (user flows, state transitions)
- Page layout design
- Visual style definition (colors, typography, component library)
- Responsive design strategy

**Output:** `docs/workflow/06-ui-ux-design.md`
- Page list and layout descriptions
- Interaction specifications (per page)
- Design tokens (colors, typography, spacing, components)
- Key page wireframes (ASCII or generated HTML mockup)

**Gate:** Human confirms design → proceed to development

---

### Phase 7: Development (frontend-dev + backend-dev, parallel)

**Input:** PRD + system design + UI UX design

**Frontend Agent receives:** API contract from system design + UI UX design specs
**Backend Agent receives:** API contract from system design + database schema

**Execution:**
- Frontend and backend develop simultaneously
- Both agents communicate via `SendMessage` for API adjustments
- Follow API contract; deviations require notifying the other agent

**Output:** Running code (no document output; code is the deliverable)

**Gate:** Both agents complete → proceed to testing

---

### Phase 8: Test Case Design + Testing (qa-tester)

**Input:** PRD + system design + code

**Execution:**
- Design test cases based on PRD (functional, boundary, exception tests)
- Write test code (unit tests, integration tests, E2E tests)
- Execute tests and record results
- Bug report and fix suggestions

**Output:**
- `docs/workflow/07-test-cases.md` — Test case document
- `docs/workflow/08-test-report.md` — Test report (pass rate, bug list, pass criteria)

**Gate:** Human confirms test results → proceed to delivery or return to development for fixes

---

### Phase 9: Delivery (deliverer)

**Input:** All documents + code + test report

**Execution:**
- Deployment checklist
- Environment configuration verification
- Delivery document aggregation

**Output:** `docs/workflow/09-delivery-checklist.md`
- Deployment steps
- Environment variable list
- Database migration scripts
- Verification checklist

**Gate:** Human confirms delivery complete

---

## State Management

### workflow-state.json

```json
{
  "projectName": "Project Name",
  "createdAt": "2026-05-16T10:00:00Z",
  "currentPhase": "market-research",
  "phases": [
    {
      "id": "topic-selection",
      "name": "Topic Selection",
      "status": "approved",
      "agent": "topic-selector",
      "output": "docs/workflow/01-topic-selection.md",
      "approvedBy": "human",
      "approvedAt": "2026-05-16T11:00:00Z",
      "notes": "Direction confirmed, focus on bookkeeping scenario"
    },
    {
      "id": "market-research",
      "name": "Market Research",
      "status": "in_progress",
      "agent": "market-researcher",
      "output": null,
      "approvedBy": null,
      "approvedAt": null,
      "notes": null
    }
  ]
}
```

Phase status values: `pending` | `in_progress` | `completed` | `approved` | `rejected`

### Document Output Directory

```
docs/workflow/
├── workflow-state.json           # State tracking
├── 01-topic-selection.md         # Topic selection report
├── 02-market-research.md         # Market research report
├── 03-product-design.md          # Product design document
├── 04-prd.md                     # PRD document
├── 05-system-design.md           # System boundary design
├── 06-ui-ux-design.md            # UI UX design specs
├── 07-test-cases.md              # Test case document
├── 08-test-report.md             # Test report
└── 09-delivery-checklist.md      # Delivery checklist
```

---

## Skill Template Structure

Each Skill follows this standard structure:

```markdown
---
name: <skill-name>
description: <one-line description>
---

# <Phase Name>

## Input
- Required documents from prior phases
- Optional user-provided context

## Execution Steps
1. Step one
2. Step two
3. ...

## Output Template
- File path: docs/workflow/XX-<name>.md
- Format and required sections

## Self-Check List
- [ ] Check item 1
- [ ] Check item 2
- [ ] ...
```

---

## Commands

| Command | Action |
|---------|--------|
| `/workflow start <idea>` | Start a new project workflow |
| `/workflow status` | Show current progress |
| `/workflow approve` | Approve current phase |
| `/workflow reject <feedback>` | Reject current phase (with feedback for redo) |
| `/workflow redo <phase>` | Redo a specific phase |
| `/workflow skip <phase>` | Skip a specific phase |

---

## Orchestrator Scheduling Logic

```
1. User invokes /workflow start [initial idea or interest domain]
2. Orchestrator initializes workflow-state.json
3. Loop:
   a. Read current phase
   b. Spawn corresponding Agent (loads corresponding Skill)
   c. Pass context (list of prior document paths)
   d. Wait for Agent completion → mark phase completed
   e. Pause, prompt human for review
   f. Human approves → mark approved → advance to next phase
   g. For development phase → spawn frontend-dev and backend-dev simultaneously
   h. For final phase → mark workflow complete
```

---

## File Structure (Plugin)

```
.claude/
├── skills/
│   ├── workflow.md                  # Orchestrator skill (main entry)
│   ├── topic-selection.md           # Phase 1
│   ├── market-research.md           # Phase 2
│   ├── product-design.md            # Phase 3
│   ├── prd-writing.md               # Phase 4
│   ├── system-design.md             # Phase 5
│   ├── ui-ux-design.md              # Phase 6
│   ├── frontend-dev.md              # Phase 7a
│   ├── backend-dev.md               # Phase 7b
│   ├── qa-testing.md                # Phase 8
│   └── delivery.md                  # Phase 9
├── agents/
│   └── (use existing agent definitions, specialized per phase)
└── hooks/
    └── (optional: auto-format, quality gates per phase)
```
