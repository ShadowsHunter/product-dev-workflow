---
name: product-design
description: "Define core features, user stories, information architecture, and user flows for the product. Phase 3 of the product development workflow."
origin: community
---

# Product Design

Turn research insights into a buildable product scope.

## Input

- `docs/workflow/01-topic-selection.md` (required)
- `docs/workflow/02-market-research.md` (required)

## Execution Steps

1. **Feature brainstorming** — Generate all possible features from:
   - Pain points in user personas
   - Competitor gaps identified in market research
   - Core value proposition from topic selection

2. **Feature prioritization (MoSCoW)**
   - P0 (Must Have): Features required for MVP — without these, the product doesn't solve the core problem
   - P1 (Should Have): Important for adoption and retention but not launch-blocking
   - P2 (Nice to Have): Enhancements that can wait until post-MVP
   - Explicitly list what is OUT OF SCOPE for MVP

3. **User story writing** — For each P0 and P1 feature:
   - Epic: broad capability area
   - Story: "As a [persona], I want to [action] so that [outcome]"
   - Acceptance criteria: testable conditions for "done"

4. **Information architecture** — Map the content/feature structure:
   - Top-level sections or navigation items
   - What lives under each section
   - How sections relate to each other

5. **Core user flows** — Map the 3-5 most critical paths:
   - Happy path (everything works)
   - Error/edge cases where relevant
   - Entry and exit points for each flow

## Output Template

Write to `docs/workflow/03-product-design.md`:

```markdown
# Product Design: [Project Name]

## Overview
[2-3 sentence summary of the product scope and design direction]

## Feature List

### P0 — Must Have (MVP)
| ID | Feature | Description | Epic |
|----|---------|-------------|------|
| F001 | [Name] | [What it does] | [Epic] |

### P1 — Should Have
| ID | Feature | Description | Epic |
|----|---------|-------------|------|

### P2 — Nice to Have
| ID | Feature | Description | Epic |
|----|---------|-------------|------|

### Out of Scope (MVP)
- [Feature or capability explicitly excluded]

## User Stories

### Epic 1: [Epic Name]
- **US-001**: As a [persona], I want to [action] so that [outcome]
  - Acceptance criteria:
    - [ ] [Testable condition 1]
    - [ ] [Testable condition 2]

### Epic 2: [Epic Name]
[Same structure]

## Information Architecture

```
[Root]
├── [Section 1]
│   ├── [Sub-section A]
│   └── [Sub-section B]
├── [Section 2]
│   └── [Sub-section C]
└── [Section 3]
```

## Core User Flows

### Flow 1: [Flow Name]
1. User [action] → System [response]
2. User [action] → System [response]
3. ...
- **Error case**: [What happens when things go wrong]

### Flow 2: [Flow Name]
[Same structure]

## Design Principles
- [Principle 1]: [Why it matters for this product]
- [Principle 2]: [Why it matters]
```

## Self-Check List

- [ ] Every P0 feature maps to a user pain point from market research
- [ ] Every P0 feature has at least one user story with acceptance criteria
- [ ] Information architecture is flat enough for easy navigation (max 3 levels)
- [ ] User flows cover the happy path for all P0 features
- [ ] MVP scope is clearly bounded — not everything is P0
- [ ] At least 2 items are explicitly out of scope

## Quality Criteria

Good enough when: a developer could start building from the feature list and user stories. Not when: features are vague ("nice UI") or acceptance criteria are untestable.
