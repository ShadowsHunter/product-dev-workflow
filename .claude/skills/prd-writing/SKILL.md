---
name: prd-writing
description: "Write a detailed Product Requirements Document with feature requirements, acceptance criteria, non-functional requirements, data model, and MVP scope. Phase 4 of the product development workflow."
origin: community
---

# PRD Writing

Turn product design into an engineering-ready specification.

## Input

- `docs/workflow/01-topic-selection.md` (required)
- `docs/workflow/02-market-research.md` (required)
- `docs/workflow/03-product-design.md` (required)

## Execution Steps

1. **Feature requirement specifications** — For each P0 feature from product design:
   - Detailed description of what the feature does
   - Input: what data/triggers the feature receives
   - Output: what the feature produces or displays
   - Business rules: constraints, validations, calculations
   - Acceptance criteria: testable "definition of done"

2. **Non-functional requirements**
   - Performance targets (response time, concurrent users, throughput)
   - Security requirements (auth model, data protection, compliance)
   - Usability requirements (accessibility, browser support, mobile)
   - Reliability (uptime, error handling, data consistency)

3. **Data model overview**
   - Core entities and their relationships
   - Key fields per entity (not exhaustive — just enough for system design)
   - Data lifecycle (creation, updates, archival, deletion)

4. **MVP scope definition**
   - Explicit list of what is in MVP (maps to P0 features)
   - What is deferred to v1.1, v2.0
   - Success metrics for MVP launch

5. **Dependencies and constraints**
   - External service dependencies
   - Technical constraints (platform, language, infrastructure)
   - Timeline or resource constraints

6. **Glossary** — Define domain-specific terms

## Output Template

Write to `docs/workflow/04-prd.md`:

```markdown
# PRD: [Project Name]

## Overview
[Product summary, target users, core value proposition]

## Feature Requirements

### F001: [Feature Name]
- **Priority**: P0
- **Description**: [Detailed description]
- **Input**: [What triggers this feature, what data it receives]
- **Output**: [What the user sees, what data is produced]
- **Business rules**:
  - [Rule 1]
  - [Rule 2]
- **Acceptance criteria**:
  - [ ] [Testable criterion 1]
  - [ ] [Testable criterion 2]
  - [ ] [Edge case handled]

### F002: [Feature Name]
[Same structure]

[Continue for all P0 features]

### P1 Features (Deferred Detail)
| ID | Feature | Brief Description | Rationale for Deferral |
|----|---------|-------------------|----------------------|
| [ID] | [Name] | [Brief] | [Why not MVP] |

## Non-Functional Requirements

### Performance
- Page load: [target]
- API response: [target]
- Concurrent users: [target]

### Security
- Authentication model: [description]
- Authorization model: [description]
- Data protection: [requirements]

### Usability
- Browser support: [list]
- Accessibility: [WCAG level]
- Mobile: [responsive/native]

### Reliability
- Uptime target: [percentage]
- Error handling: [strategy]
- Data backup: [approach]

## Data Model

### Core Entities
- **[Entity 1]**: [Description]
  - Key fields: [field list]
  - Relationships: [related entities]
- **[Entity 2]**: [Description]
  - Key fields: [field list]
  - Relationships: [related entities]

### Entity Relationships
```
[Entity 1] --1:N--> [Entity 2]
[Entity 2] --N:1--> [Entity 3]
```

## MVP Scope

### In Scope (MVP)
- [Feature list from P0]

### Deferred (v1.1+)
- [Feature list from P1/P2 with target version]

### MVP Success Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| [Metric] | [Target] | [How measured] |

## Dependencies and Constraints
- **External services**: [list]
- **Technical constraints**: [list]
- **Resource constraints**: [list]

## Glossary
| Term | Definition |
|------|-----------|
| [Term] | [Definition] |
```

## Self-Check List

- [ ] Every P0 feature has detailed requirements (not just a name)
- [ ] Every P0 feature has testable acceptance criteria (can a QA engineer verify it?)
- [ ] Non-functional requirements are specific (numbers, not "fast" or "secure")
- [ ] Data model covers all entities referenced in feature requirements
- [ ] MVP scope is clearly bounded and defensible
- [ ] Edge cases are addressed in acceptance criteria
- [ ] No orphan references (every entity mentioned is defined)

## Quality Criteria

Good enough when: an engineer can implement a feature without asking clarifying questions. Not when: acceptance criteria are vague ("works correctly") or features lack input/output specifications.
