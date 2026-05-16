---
name: backend-dev
description: "Implement the backend API based on system design API contract and database schema. Phase 7b of the product development workflow (parallel with frontend-dev)."
origin: community
---

# Backend Development

Build a working API that implements the contract from system design.

## Input

- `docs/workflow/05-system-design.md` (required — API contract, database schema, deployment)

## Execution Steps

1. **Project scaffolding**
   - Initialize project with the chosen framework (from system design)
   - Set up folder structure (routes, controllers, models, middleware, config, migrations)
   - Configure TypeScript (if applicable)
   - Set up linting and formatting

2. **Database setup**
   - Configure database connection
   - Create migrations in numbered order matching the schema from system design
   - Ensure all migrations are reversible (up and down)
   - Run migrations to create tables
   - Set up seed data for development

3. **Authentication and authorization**
   - Implement the auth model from system design
   - Create registration and login endpoints
   - Implement token management (JWT or session)
   - Create auth middleware for protected routes
   - Implement role-based access control if specified

4. **API endpoints** — Implement each endpoint from the API contract:
   - Match the exact HTTP method, path, request/response schemas
   - Implement request validation
   - Implement business logic from PRD requirements
   - Return correct status codes (200, 201, 400, 401, 403, 404, 500)
   - Return consistent error response format

5. **Error handling**
   - Global error handler middleware
   - Consistent error response format: `{ "error": "message" }`
   - Proper logging of errors (no sensitive data in logs)
   - Graceful handling of database errors

6. **API documentation**
   - Ensure code matches the contract from system design
   - Add endpoint descriptions in code comments or OpenAPI spec
   - Document any deviations from the original contract

7. **Environment configuration**
   - Set up `.env.example` with all required variables from system design
   - Validate required environment variables at startup
   - Use configuration module for environment-specific settings

8. **Health check**
   - Implement `GET /health` endpoint
   - Return `{ "status": "ok" }` with database connectivity check

## Output

Running backend code — no document output. Code is the deliverable.

The backend should:
- Be runnable with `npm run dev` (or equivalent)
- Serve all P0 API endpoints from the contract
- Return correct status codes and response formats
- Handle authentication and authorization
- Have reversible database migrations

## Self-Check List

- [ ] Project scaffolding matches the tech stack from system design
- [ ] All database tables from the schema are created via migrations
- [ ] Migrations are reversible (have down methods)
- [ ] Every API endpoint from the contract is implemented
- [ ] Request validation matches the contract schemas
- [ ] Response format matches the contract schemas exactly
- [ ] Authentication is implemented and tested
- [ ] Authorization middleware protects the correct routes
- [ ] Error responses are consistent and don't leak sensitive data
- [ ] Health check endpoint returns 200
- [ ] `.env.example` lists all required environment variables

## Quality Criteria

Good enough when: a frontend can call all P0 endpoints and receive the correct responses. Not when: endpoints return different shapes than the contract specifies or migrations are missing.
