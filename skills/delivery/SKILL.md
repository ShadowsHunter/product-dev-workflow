---
name: delivery
description: "Create deployment checklist, environment configuration, and delivery documentation to ship the product. Phase 9 (final) of the product development workflow."
origin: community
---

# Delivery

Package everything needed to ship the product to production.

## Input

- `docs/workflow/01-topic-selection.md`
- `docs/workflow/02-market-research.md`
- `docs/workflow/03-product-design.md`
- `docs/workflow/04-prd.md`
- `docs/workflow/05-system-design.md`
- `docs/workflow/06-ui-ux-design.md`
- `docs/workflow/07-test-cases.md`
- `docs/workflow/08-test-report.md`
- All frontend and backend code
- Test results

## Execution Steps

1. **Deployment checklist** — Step-by-step guide to go from code to live:
   - Prerequisites (accounts, domains, SSL)
   - Build steps (frontend build, backend build)
   - Database migration execution order
   - Environment variable configuration
   - DNS and routing setup
   - SSL/TLS certificate setup
   - Smoke test after deployment

2. **Environment configuration**
   - List all environment variables with descriptions
   - Mark which are required vs optional
   - Note any secrets that need secure storage
   - Provide example values (non-sensitive)

3. **Database migration scripts**
   - List all migrations in execution order
   - Include rollback instructions
   - Note any data migration (not just schema) steps

4. **Verification checklist** — Post-deployment checks:
   - Health check endpoint returns 200
   - Frontend loads and renders
   - Authentication works (signup, login)
   - All P0 user flows work end-to-end
   - No console errors on key pages
   - Performance is acceptable (no 10s page loads)

5. **Rollback plan**
   - How to revert a failed deployment
   - Database rollback steps
   - DNS rollback if applicable
   - Communication plan (who to notify)

6. **Delivery document aggregation**
   - Link all workflow documents
   - Summary of what was built vs. original scope
   - Known issues and their status
   - Future roadmap (P1/P2 features)

## Output Template

Write to `docs/workflow/09-delivery-checklist.md`:

```markdown
# Delivery Checklist: [Project Name]

## Pre-Deployment

### Prerequisites
- [ ] Production account created on [platform]
- [ ] Domain configured and DNS accessible
- [ ] SSL certificate provisioned
- [ ] Database instance provisioned
- [ ] CI/CD pipeline configured

### Build
- [ ] Frontend builds without errors (`npm run build`)
- [ ] Backend builds without errors
- [ ] No TypeScript errors
- [ ] No lint warnings in production code

## Deployment Steps

### Step 1: Database Migration
```bash
[Migration command]
```
- [ ] Migrations run successfully
- [ ] Verify tables exist: [list key tables]

### Step 2: Backend Deployment
```bash
[Deploy command]
```
- [ ] Backend health check returns 200: `curl [health-url]`

### Step 3: Frontend Deployment
```bash
[Deploy command]
```
- [ ] Frontend loads at [URL]

### Step 4: DNS and Routing
- [ ] Domain points to frontend
- [ ] API subdomain points to backend
- [ ] SSL is active (HTTPS works)

## Environment Variables

| Variable | Description | Required | Example |
|----------|-------------|----------|---------|
| [NAME] | [What it does] | Yes/No | [Non-sensitive example] |

## Post-Deployment Verification

### Smoke Tests
- [ ] `GET /health` returns `{ "status": "ok" }`
- [ ] Frontend homepage loads (< 3s)
- [ ] User can sign up
- [ ] User can log in
- [ ] [P0 Feature 1] works end-to-end
- [ ] [P0 Feature 2] works end-to-end
- [ ] No console errors on key pages
- [ ] Mobile responsive at 375px

### Performance
- [ ] Homepage LCP < 2.5s
- [ ] API response time < 500ms for P0 endpoints

## Rollback Plan

1. [Rollback step 1]
2. [Rollback step 2]
3. Notify: [who to contact]

## Project Summary

### What Was Built
[Feature summary, matching PRD scope]

### Known Issues
| Issue | Severity | Status | Workaround |
|-------|----------|--------|------------|
| [Issue] | [Sev] | [Open/Fixed] | [If any] |

### Future Roadmap
| Feature | Priority | Target |
|---------|----------|--------|
| [Feature] | P1/P2 | [Version] |

### Document Index
| Document | Path |
|----------|------|
| Topic Selection | docs/workflow/01-topic-selection.md |
| Market Research | docs/workflow/02-market-research.md |
| Product Design | docs/workflow/03-product-design.md |
| PRD | docs/workflow/04-prd.md |
| System Design | docs/workflow/05-system-design.md |
| UI/UX Design | docs/workflow/06-ui-ux-design.md |
| Test Cases | docs/workflow/07-test-cases.md |
| Test Report | docs/workflow/08-test-report.md |
```

## Self-Check List

- [ ] Deployment steps are executable by someone who didn't build the project
- [ ] All environment variables are listed with descriptions
- [ ] Database migrations are listed in execution order
- [ ] Rollback plan exists and is actionable
- [ ] Smoke tests cover all P0 features
- [ ] Known issues are documented with severity
- [ ] All workflow documents are linked

## Quality Criteria

Good enough when: a new team member could deploy the project by following the checklist. Not when: steps assume prior knowledge or environment variables are missing.
