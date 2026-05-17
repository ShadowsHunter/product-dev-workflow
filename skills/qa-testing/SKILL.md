---
name: qa-testing
description: "Design test cases, write test code, execute tests, and produce a test report. Phase 8 of the product development workflow. Includes mandatory P0/P1 fix-retest loop."
origin: community
---

# QA Testing

Verify the product works as specified, not just as built. P0/P1 bugs are mandatory fixed before human review.

## Input

- `docs/workflow/04-prd.md` (required — acceptance criteria)
- `docs/workflow/05-system-design.md` (required — API contract)
- Running frontend and backend code

## Execution Steps

1. **Test case design** — For each P0 feature from the PRD:
   - **Functional tests**: Verify each acceptance criterion
   - **Boundary tests**: Edge cases (empty input, max length, special characters, negative numbers)
   - **Exception tests**: Error handling (invalid auth, missing data, server errors)
   - Map each test case to the PRD acceptance criterion it validates

2. **Unit tests** — Test individual functions and utilities:
   - Data transformation functions
   - Validation logic
   - Business rule calculations
   - API client request building

3. **Integration tests** — Test API endpoints:
   - Happy path for each endpoint
   - Validation failures (400 responses)
   - Authentication failures (401 responses)
   - Authorization failures (403 responses)
   - Not found cases (404 responses)
   - Use the API contract from system design as the test specification

4. **E2E tests** — Test critical user flows:
   - Map the user flows from product design
   - Test complete journeys (signup → use feature → see result)
   - Use Playwright or equivalent
   - Test at desktop and mobile viewport

5. **Test execution**
   - Run all test suites
   - Record results per test case
   - Categorize failures by severity

6. **Bug report** — For each failing test:
   - Expected behavior (from PRD)
   - Actual behavior (what happened)
   - Steps to reproduce
   - Severity: P0 Critical (data loss, security), P1 High (feature broken), P2 Medium (degraded UX), P3 Low (cosmetic)

## Bug Severity Definitions

| Severity | Label | Meaning | Requires Fix |
|----------|-------|---------|-------------|
| P0 | Critical | Data loss, security vulnerability, system crash | **Mandatory** |
| P1 | High | Core feature broken, no workaround | **Mandatory** |
| P2 | Medium | Feature degraded, workaround exists | Optional (human decides) |
| P3 | Low | Cosmetic, minor UX issue | Optional (human decides) |

## Fix-Retest Loop

After each test round, check the results:

```
ROUND 1:
  Run tests → Categorize bugs by severity
  IF P0/P1 bugs exist:
    → Pass bug list to fix agents (frontend-dev + backend-dev)
    → Wait for fixes to complete
    → GOTO ROUND 2
  ELSE:
    → Produce final test report
    → Open approval gate for human

ROUND 2+:
  Re-run ALL tests (not just previously failing ones)
  IF P0/P1 bugs still exist:
    → Pass remaining bug list to fix agents
    → Wait for fixes
    → GOTO NEXT ROUND
  ELSE:
    → Produce final test report with all round history
    → Open approval gate

MAX ROUNDS: 5
  If P0/P1 bugs persist after 5 rounds:
    → Produce test report with all round history
    → Open approval gate with a WARNING
    → Let human decide whether to continue fixing or accept
```

The fix-retest loop is automatic. The human is NOT consulted between rounds — the orchestrator drives the loop internally. The human only sees the final result.

## Output Template

### Test Cases Document

Write to `docs/workflow/07-test-cases.md`:

```markdown
# Test Cases: [Project Name]

## Test Strategy
- **Unit tests**: [framework, coverage target]
- **Integration tests**: [framework, what's tested]
- **E2E tests**: [framework, what's tested]

## Test Cases by Feature

### F001: [Feature Name]
| TC ID | Type | Description | Input | Expected | PRD Criterion |
|-------|------|-------------|-------|----------|---------------|
| TC-001 | Functional | [What it tests] | [Test input] | [Expected result] | [Which AC] |
| TC-002 | Boundary | [What it tests] | [Edge case input] | [Expected result] | [Which AC] |
| TC-003 | Exception | [What it tests] | [Invalid input] | [Error response] | [Which AC] |

### F002: [Feature Name]
[Same structure]

## E2E Test Scenarios

### Scenario 1: [Flow Name]
1. [Step 1]
2. [Step 2]
3. Assert [expected result]

[Continue for all P0 features]
```

### Test Report

Write to `docs/workflow/08-test-report.md`:

```markdown
# Test Report: [Project Name]

## Summary
| Metric | Value |
|--------|-------|
| Total test rounds | [count] |
| Total test cases | [count] |
| Passed | [count] |
| Failed | [count] |
| Pass rate | [%] |
| Coverage | [%] |
| P0/P1 bugs remaining | [count] |

## Test Round History

### Round 1
| Metric | Value |
|--------|-------|
| Passed | [count] |
| Failed | [count] |
| P0 bugs | [count] |
| P1 bugs | [count] |
| Action taken | [Fixed N bugs / No P0/P1, done] |

### Round 2 (if applicable)
[Same structure]

## Results by Feature (Final Round)

### F001: [Feature Name]
| TC ID | Result | Notes |
|-------|--------|-------|
| TC-001 | PASS | |
| TC-002 | PASS | [Previously failed in round N, fixed] |

[Continue for all features]

## Resolved Bugs (fixed during test rounds)

### BUG-001: [Bug Title] (FIXED in Round N)
- **Severity**: P0/P1
- **Feature**: [Which feature]
- **Root cause**: [What caused it]
- **Fix**: [What was changed]

## Remaining Bugs (P2/P3 only — human decides)

### BUG-010: [Bug Title]
- **Severity**: P2/P3
- **Feature**: [Which feature]
- **Expected**: [What should happen]
- **Actual**: [What happened]
- **Reproduction**: [Steps]

## Recommendation
- [ ] Ship — All tests pass, no remaining bugs
- [ ] Ship with known issues — All P0/P1 fixed, P2/P3 documented
- [ ] Needs more work — (only if max rounds reached with P0/P1 remaining)
```

## Self-Check List

- [ ] Every P0 feature from the PRD has test cases
- [ ] Every acceptance criterion from the PRD has at least one test case
- [ ] Boundary and exception cases are tested, not just happy path
- [ ] Test results are factual (actual outcomes, not assumptions)
- [ ] Bugs are categorized by severity (P0/P1/P2/P3) with reproduction steps
- [ ] All P0/P1 bugs have been fixed and verified in a retest round
- [ ] Pass rate and coverage are documented
- [ ] Round history shows the fix-retest progression
- [ ] Recommendation is clear and justified by the data

## Quality Criteria

Good enough when: every P0 acceptance criterion has a PASS result, and all P0/P1 bugs are resolved. Not when: only happy path is tested, P0/P1 bugs remain unfixed, or failures aren't documented.
