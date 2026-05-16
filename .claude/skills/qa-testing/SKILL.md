---
name: qa-testing
description: "Design test cases, write test code, execute tests, and produce a test report. Phase 8 of the product development workflow."
origin: community
---

# QA Testing

Verify the product works as specified, not just as built.

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
   - Severity: Critical (data loss, security), High (feature broken), Medium (degraded UX), Low (cosmetic)

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
| Total test cases | [count] |
| Passed | [count] |
| Failed | [count] |
| Pass rate | [%] |
| Coverage | [%] |

## Results by Feature

### F001: [Feature Name]
| TC ID | Result | Notes |
|-------|--------|-------|
| TC-001 | PASS | |
| TC-002 | FAIL | [What went wrong] |

[Continue for all features]

## Bug List

### BUG-001: [Bug Title]
- **Severity**: Critical / High / Medium / Low
- **Feature**: [Which feature]
- **Expected**: [What should happen]
- **Actual**: [What happened]
- **Reproduction**: [Steps]
- **Suggested fix**: [If known]

[Continue for all bugs]

## Recommendation
- [ ] Ship — All P0 tests pass, known bugs are acceptable
- [ ] Ship with known issues — P0 tests pass, non-critical bugs documented
- [ ] Do not ship — Critical or high severity bugs must be fixed first
```

## Self-Check List

- [ ] Every P0 feature from the PRD has test cases
- [ ] Every acceptance criterion from the PRD has at least one test case
- [ ] Boundary and exception cases are tested, not just happy path
- [ ] Test results are factual (actual outcomes, not assumptions)
- [ ] Bugs are categorized by severity with reproduction steps
- [ ] Pass rate and coverage are documented
- [ ] Recommendation is clear and justified by the data

## Quality Criteria

Good enough when: every P0 acceptance criterion has a test result (pass or fail with details). Not when: only happy path is tested or failures aren't documented.
