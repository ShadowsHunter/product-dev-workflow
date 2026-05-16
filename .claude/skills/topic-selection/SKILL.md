---
name: topic-selection
description: "Validate and refine a product idea through feasibility assessment, market signal analysis, and recommendation. First phase of the product development workflow."
origin: community
---

# Topic Selection

Select a viable product topic grounded in evidence, not gut feeling.

## Input

### Mode A: User provides an idea
- Raw idea description (text)
- Any constraints or preferences the user mentions

### Mode B: User provides an interest domain
- Domain or skill direction
- Target market segment (if any)

## Execution Steps

1. **Clarify the idea** — If Mode A, distill the raw idea into a one-line problem statement. If Mode B, scan current trends (GitHub Trending, Product Hunt, industry reports) and generate 3-5 candidate topics.

2. **Market signal check** — Assess whether real demand exists:
   - Search for existing solutions and their traction
   - Identify search volume signals or community discussions
   - Note if this is a growing, stable, or declining space

3. **Technical feasibility check** — Can this be built with reasonable effort?
   - Identify core technical requirements
   - Assess whether required APIs, data sources, or infrastructure are accessible
   - Estimate complexity: simple (weeks), moderate (1-2 months), complex (3+ months)

4. **Target user identification** — Who specifically would use this?
   - Define primary user persona (role, context, pain point)
   - Estimate user population size (rough order of magnitude)
   - Identify user acquisition channels

5. **Differentiation angle** — Why would someone choose this over alternatives?
   - List 2-3 existing alternatives (direct or indirect)
   - Identify a specific angle (price, UX, niche, integration, speed)

6. **Feasibility rating** — Assign an overall rating:
   - **High**: Clear demand, technically straightforward, identifiable users
   - **Medium**: Some demand signals, moderate complexity, users need validation
   - **Low**: Uncertain demand, high complexity, or crowded market

7. **Recommendation** — Write a clear go/no-go recommendation with rationale

## Output Template

Write to `docs/workflow/01-topic-selection.md`:

```markdown
# Topic Selection: [Project Name]

## One-Line Description
[Clear, specific product description]

## Problem Statement
[What problem does this solve? For whom? Why now?]

## Target User Profile
- **Primary user**: [Role/persona description]
- **Context**: [When and where they encounter the problem]
- **Current solutions**: [What they do today]
- **Pain point**: [Specific frustration or unmet need]

## Feasibility Assessment

### Market Signal
- Demand indicators: [evidence]
- Existing solutions: [list with traction notes]
- Market direction: [growing/stable/declining]

### Technical Feasibility
- Core requirements: [list]
- Complexity: [simple/moderate/complex]
- Key dependencies: [APIs, data, infrastructure]

### User Reach
- Estimated audience: [order of magnitude]
- Acquisition channels: [list]

## Overall Rating: [High/Medium/Low]

## Recommendation
[Go/no-go with 2-3 sentence rationale]
```

## Self-Check List

- [ ] Problem statement is specific enough that a stranger could understand it
- [ ] Target user is identifiable (not "everyone")
- [ ] At least 2 existing alternatives were identified
- [ ] Feasibility rating is grounded in evidence, not optimism
- [ ] Recommendation follows logically from the assessment
- [ ] Topic is narrow enough to build as an MVP (not a platform)

## Quality Criteria

Good enough when: a developer could read this document and start building. Not when: it reads like a pitch deck with no substance.
