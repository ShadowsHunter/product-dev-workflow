---
name: market-research
description: "Conduct competitive analysis, market sizing, user persona development, and differentiation strategy for a product idea. Phase 2 of the product development workflow."
origin: community
---

# Market Research

Produce research that supports decisions, not research theater.

## Input

- `docs/workflow/01-topic-selection.md` (required)

## Execution Steps

1. **Competitive landscape mapping**
   - Identify 3-5 direct competitors (solve the same problem)
   - Identify 2-3 indirect competitors (solve adjacent problems)
   - For each: product offering, pricing, strengths, weaknesses, traction signals

2. **Market size estimation (TAM/SAM/SOM)**
   - TAM (Total Addressable Market): top-down from industry reports or public data
   - SAM (Serviceable Addressable Market): filter by geography, segment, or capability
   - SOM (Serviceable Obtainable Market): realistic capture in 1-2 years
   - Label every number as sourced or estimated with assumptions

3. **User persona development** — Create 2-3 specific personas:
   - Name, role, demographics (rough)
   - Goals and motivations
   - Pain points and frustrations
   - Current behavior and tools
   - How they'd discover this product

4. **Differentiation positioning**
   - Map competitors on 2 key dimensions (e.g., price vs. complexity, power vs. ease-of-use)
   - Identify the positioning gap this product fills
   - Define the unique value proposition in one sentence

5. **Risk assessment**
   - Market risks (timing, saturation, regulation)
   - Technical risks (dependencies, complexity)
   - Business risks (monetization, user acquisition cost)

## Output Template

Write to `docs/workflow/02-market-research.md`:

```markdown
# Market Research: [Project Name]

## Executive Summary
[3-5 key findings that drive the recommendation]

## Competitive Analysis

### Direct Competitors
| Competitor | Offering | Pricing | Strengths | Weaknesses | Traction |
|-----------|----------|---------|-----------|------------|----------|
| [Name]    | [Brief]  | [Model] | [Key]     | [Key]      | [Signal] |

### Indirect Competitors
| Competitor | Relevance | Key Difference |
|-----------|-----------|----------------|
| [Name]    | [Why listed] | [How they differ] |

## Market Size
| Metric | Value | Source / Assumption |
|--------|-------|-------------------|
| TAM    | [Value] | [Source] |
| SAM    | [Value] | [Calculation] |
| SOM    | [Value] | [Assumption] |

## User Personas

### Persona 1: [Name] — [Role/Archetype]
- **Context**: [Background]
- **Goals**: [What they want to achieve]
- **Pain points**: [Specific frustrations]
- **Current tools**: [What they use today]
- **Discovery path**: [How they'd find this product]

### Persona 2: [Name] — [Role/Archetype]
[Same structure]

### Persona 3: [Name] — [Role/Archetype]
[Same structure]

## Differentiation Strategy
- **Positioning**: [Where we sit vs. competitors]
- **Unique value proposition**: [One sentence]
- **Why now**: [Timing advantage]

## Risk Assessment
| Risk | Category | Likelihood | Impact | Mitigation |
|------|----------|-----------|--------|------------|
| [Risk] | [Market/Tech/Business] | [H/M/L] | [H/M/L] | [Action] |

## Sources
- [List all sources with URLs or descriptions]
```

## Self-Check List

- [ ] Every competitor has specific, factual data (not generic descriptions)
- [ ] Market size numbers are labeled as sourced or estimated
- [ ] Personas are specific enough to feel like real people (not archetypes)
- [ ] Differentiation is defensible (not just "we're better")
- [ ] At least 3 risks identified with mitigation strategies
- [ ] Contrarian evidence or downside cases are included

## Quality Criteria

Good enough when: a product manager could use this to brief a design team. Not when: it's a wall of numbers without interpretation.
