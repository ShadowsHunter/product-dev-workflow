---
name: ui-ux-design
description: "Define visual style, page layouts, interaction specifications, and wireframes for the product UI. Phase 6 of the product development workflow (parallel with system-design)."
origin: community
---

# UI/UX Design

Design a user interface that is intentional, usable, and specific to the product.

## Input

- `docs/workflow/04-prd.md` (required)
- `docs/workflow/03-product-design.md` (required)

## Execution Steps

1. **Design direction selection** — Choose a specific visual direction (not generic "clean minimal"):
   - Identify 2-3 reference sites or products with similar feel
   - State the design personality (e.g., editorial, neo-brutalist, glassmorphism, Swiss)
   - Define the emotional response the UI should evoke

2. **Design tokens** — Define concrete visual values:
   - Colors: primary, secondary, surface, text, error, success (hex/hsl/oklch values)
   - Typography: font families, sizes (heading/body/caption), weights, line heights
   - Spacing: scale values (4, 8, 16, 24, 32, 48, 64)
   - Border radius: values for cards, buttons, inputs
   - Shadows: elevation levels
   - Motion: duration and easing curves

3. **Component library** — Define core UI components:
   - Button variants (primary, secondary, ghost, destructive)
   - Input fields (text, email, password, textarea, select)
   - Cards, modals, toasts
   - Navigation patterns
   - Loading and empty states

4. **Page list and layouts** — For each page:
   - Page name and purpose
   - Layout description (grid structure, sections, content hierarchy)
   - Key components used
   - Responsive behavior at breakpoints

5. **Interaction specifications** — For each page:
   - User actions available
   - State transitions (loading, success, error, empty)
   - Hover, focus, and active states
   - Keyboard navigation where relevant

6. **Wireframes** — Draw key page layouts:
   - Use ASCII art or generate HTML mockup
   - Cover all P0 user flows
   - Show at least desktop and one mobile breakpoint

7. **Responsive strategy**
   - Breakpoints: mobile (<768), tablet (768-1024), desktop (>1024)
   - Layout shifts at each breakpoint
   - Touch target considerations for mobile

8. **Accessibility notes**
   - Color contrast requirements
   - Keyboard navigation requirements
   - Screen reader considerations
   - Motion reduction support

## Output Template

Write to `docs/workflow/06-ui-ux-design.md`:

```markdown
# UI/UX Design: [Project Name]

## Design Direction
- **Style**: [Specific direction name]
- **Personality**: [3-5 adjectives describing the visual feel]
- **References**: [2-3 URLs or product names]
- **Emotional goal**: [What users should feel]

## Design Tokens

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| --color-primary | [hex/hsl] | Primary actions, links |
| --color-secondary | [hex/hsl] | Secondary elements |
| --color-surface | [hex/hsl] | Backgrounds |
| --color-text | [hex/hsl] | Body text |
| --color-error | [hex/hsl] | Error states |
| --color-success | [hex/hsl] | Success states |

### Typography
| Token | Value | Usage |
|-------|-------|-------|
| --font-heading | [family, weight] | Headings |
| --font-body | [family, weight] | Body text |
| --text-hero | [size] | Hero heading |
| --text-h1 | [size] | Section headings |
| --text-body | [size] | Body paragraphs |
| --text-caption | [size] | Labels, hints |

### Spacing
| Token | Value |
|-------|-------|
| --space-xs | [value] |
| --space-sm | [value] |
| --space-md | [value] |
| --space-lg | [value] |
| --space-xl | [value] |

### Motion
| Token | Value |
|-------|-------|
| --duration-fast | [ms] |
| --duration-normal | [ms] |
| --ease-default | [cubic-bezier] |

## Component Library

### Button
- **Variants**: primary, secondary, ghost, destructive
- **States**: default, hover, focus, active, disabled, loading
- **Sizes**: sm, md, lg
- **Spec**: [padding, border-radius, font, transition details]

### Input
- **Types**: text, email, password, textarea, select
- **States**: default, focus, error, disabled
- **Spec**: [padding, border, font, label positioning]

### Card
- **Spec**: [padding, shadow, border-radius, background]
- **Variants**: default, highlighted, interactive

[Continue for all core components]

## Pages

### Page 1: [Page Name]
- **Route**: [URL path]
- **Purpose**: [What the user does here]
- **Layout**:
  ```
  ┌──────────────────────────────────────┐
  │ [Navigation]                         │
  ├──────────────────────────────────────┤
  │ [Content area description]           │
  │ [Component placement]                │
  └──────────────────────────────────────┘
  ```
- **Components used**: [list]
- **Responsive behavior**:
  - Desktop: [description]
  - Mobile: [description]

### Page 2: [Page Name]
[Same structure]

## Interaction Specifications

### [Page Name] Interactions
| Action | Trigger | Response | State Change |
|--------|---------|----------|-------------|
| [Action] | [Click/Type/etc] | [What happens] | [Loading→Success/Error] |

### Global Interactions
| Pattern | Behavior |
|---------|----------|
| Loading | [Skeleton/Spinner/Progress] |
| Error | [Toast/Inline/Modal] |
| Empty state | [Illustration + CTA] |
| Success | [Toast/Redirect] |

## Key Wireframes

### [Flow Name] — Desktop (1440px)
```
┌─────────────────────────────────────────────────────────┐
│ [Navigation Bar]                                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ [Wireframe content with component labels]               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### [Flow Name] — Mobile (375px)
```
┌───────────────────┐
│ [Nav - hamburger]  │
├───────────────────┤
│ [Stacked content]  │
└───────────────────┘
```

## Responsive Breakpoints
| Breakpoint | Width | Layout Changes |
|-----------|-------|---------------|
| Mobile | <768px | [Description] |
| Tablet | 768-1024px | [Description] |
| Desktop | >1024px | [Description] |

## Accessibility Notes
- [Requirement 1]
- [Requirement 2]
```

## Self-Check List

- [ ] Design direction is specific (not "clean and modern")
- [ ] Design tokens have concrete values (hex colors, pixel sizes, not "blue" or "large")
- [ ] Every P0 page from product design has a layout description
- [ ] Every P0 user flow has a wireframe
- [ ] Interaction states are defined (loading, error, empty, success)
- [ ] Responsive behavior is described for at least 2 breakpoints
- [ ] Accessibility requirements are stated

## Quality Criteria

Good enough when: a frontend developer could build the UI from the tokens, components, and wireframes without asking design questions. Not when: tokens are vague or wireframes are missing for key flows.
