---
name: frontend-dev
description: "Implement the frontend application based on system design API contract and UI/UX design specs. Phase 7a of the product development workflow (parallel with backend-dev)."
origin: community
---

# Frontend Development

Build a working frontend that matches the design spec and integrates with the API contract.

## Input

- `docs/workflow/05-system-design.md` (required — API contract section)
- `docs/workflow/06-ui-ux-design.md` (required — design tokens, components, wireframes)

## Execution Steps

1. **Project scaffolding**
   - Initialize project with the chosen framework (from system design)
   - Set up folder structure (components, hooks, lib, styles, routes)
   - Configure TypeScript (if applicable)
   - Configure path aliases
   - Set up linting and formatting

2. **Design token implementation**
   - Convert design tokens to CSS custom properties or theme configuration
   - Set up typography (import fonts, define font-face if needed)
   - Implement spacing scale
   - Define color palette in the project's theming system

3. **Core UI components** — Build the component library from ui-ux-design:
   - Button, Input, Card, Modal, Toast
   - Follow the exact specs from the design doc (padding, radius, colors, states)
   - Implement hover, focus, active, disabled, loading states
   - Ensure accessibility (ARIA labels, keyboard navigation, focus management)

4. **Layout components**
   - Navigation (responsive: desktop sidebar/mobile hamburger)
   - Page shell (header, content area, footer)
   - Responsive grid system

5. **Routing and pages**
   - Set up router with all page routes from ui-ux-design
   - Create page shell components for each route
   - Implement navigation links

6. **API client layer**
   - Create API client module following the endpoints from system-design
   - Implement request/response types matching the API contract exactly
   - Add error handling and response parsing
   - Set up authentication token management

7. **State management**
   - Set up client state management (from system design choice)
   - Implement server state management (TanStack Query or equivalent)
   - Create hooks for data fetching mutations

8. **Feature implementation** — For each P0 feature:
   - Build the page/section from wireframes
   - Connect to API client
   - Implement interaction states (loading, error, empty, success)
   - Handle form validation per the PRD business rules

9. **Responsive implementation**
   - Test at all breakpoints (375, 768, 1024, 1440)
   - Ensure touch targets are adequate on mobile
   - Verify layout shifts match responsive strategy

10. **Polish**
    - Add motion/transitions from design tokens
    - Verify all accessibility requirements
    - Remove console.logs and debug artifacts

## Output

Running frontend code — no document output. Code is the deliverable.

The frontend should:
- Be runnable with `npm run dev` (or equivalent)
- Display all P0 pages with correct layouts
- Show correct loading, error, and empty states
- Work at all breakpoints
- Match design tokens from ui-ux-design

## Self-Check List

- [ ] Project scaffolding matches the tech stack from system design
- [ ] Design tokens are implemented with exact values from ui-ux-design
- [ ] All core UI components have all interaction states (hover, focus, active, disabled, loading)
- [ ] Every P0 page route exists and renders the correct layout
- [ ] API client matches the endpoint contract from system design exactly
- [ ] Loading, error, and empty states are implemented for all data-fetching components
- [ ] Responsive at 375px, 768px, 1024px, 1440px
- [ ] No console.log or debug code in production files
- [ ] Accessibility: focus management, ARIA labels, keyboard navigation work

## Quality Criteria

Good enough when: a user can navigate all P0 flows and the UI matches the design spec. Not when: pages are blank skeletons or the API client doesn't match the contract.
