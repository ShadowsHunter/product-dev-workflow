# Product Development Workflow

AI-driven product development workflow for Claude Code — a structured, stage-gated process from topic selection through delivery.

## Overview

A 9-phase product development workflow where:

- **Orchestrator** manages phase transitions, state, and approval gates
- **Phase Skills** define domain knowledge for each stage
- **Execution Agents** are spawned per phase to produce deliverables
- **Humans** make decisions and approve at every stage gate

Target: software products (Web apps, SaaS, mobile apps).

## Phases

```
1. Topic Selection    → Validate and refine the product idea
2. Market Research    → Competitive analysis, personas, market sizing
3. Product Design     → Features, user stories, IA, user flows
4. PRD Writing        → Detailed requirements, acceptance criteria, MVP scope
5. System Design      → Tech stack, API contract, DB schema (parallel with 6)
6. UI/UX Design       → Design tokens, layouts, wireframes (parallel with 5)
7. Frontend + Backend → Parallel development
8. QA Testing         → Test cases, test execution, bug report
9. Delivery           → Deployment checklist, env config, verification
```

## Installation

### Option 1: Clone and Install

```bash
git clone https://github.com/ShadowsHunter/product-dev-workflow.git
cd product-dev-workflow
./install.sh /path/to/your/project
```

### Option 2: One-liner (curl)

```bash
bash <(curl -sL https://raw.githubusercontent.com/ShadowsHunter/product-dev-workflow/main/install.sh)
```

Run this from your project's root directory.

## Usage

```bash
# Start a new product workflow
/workflow start Build a bookkeeping app for freelancers

# Check progress
/workflow status

# Approve current phase
/workflow approve

# Reject and request revision
/workflow reject Need more detail on competitor pricing

# Redo from a specific phase
/workflow redo market-research

# Skip a phase
/workflow skip ui-ux-design
```

## Architecture

```
Project Root
├── .claude/
│   ├── commands/
│   │   └── workflow.md          # /workflow command entry point
│   └── skills/
│       ├── workflow/             # Orchestrator skill
│       ├── topic-selection/      # Phase 1
│       ├── market-research/      # Phase 2
│       ├── product-design/       # Phase 3
│       ├── prd-writing/          # Phase 4
│       ├── system-design/        # Phase 5 (parallel)
│       ├── ui-ux-design/        # Phase 6 (parallel)
│       ├── frontend-dev/         # Phase 7a (parallel)
│       ├── backend-dev/          # Phase 7b (parallel)
│       ├── qa-testing/           # Phase 8
│       └── delivery/             # Phase 9
└── docs/workflow/                # Output documents (created at runtime)
    ├── workflow-state.json
    ├── 01-topic-selection.md
    ├── 02-market-research.md
    ├── 03-product-design.md
    ├── 04-prd.md
    ├── 05-system-design.md
    ├── 06-ui-ux-design.md
    ├── 07-test-cases.md
    ├── 08-test-report.md
    └── 09-delivery-checklist.md
```

## How It Works

1. `/workflow start` initializes state and spawns the first agent
2. Each agent reads its skill, reads prior phase outputs, produces its deliverable
3. After each phase, the orchestrator pauses for human approval
4. Human runs `/workflow approve` to proceed or `/workflow reject` to redo
5. System Design + UI/UX Design run in parallel (Phase 5+6)
6. Frontend Dev + Backend Dev run in parallel (Phase 7)
7. State persists in `workflow-state.json` — survives `/clear` and session restarts

## Requirements

- Claude Code CLI or Claude Code desktop app
- No external dependencies

## License

MIT
