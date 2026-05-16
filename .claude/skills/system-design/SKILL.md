---
name: system-design
description: "Design the technical architecture including tech stack, API contract, database schema, and deployment plan. Phase 5 of the product development workflow (parallel with ui-ux-design)."
origin: community
---

# System Design

Design the technical foundation that makes the PRD buildable.

## Input

- `docs/workflow/04-prd.md` (required)

## Execution Steps

1. **Tech stack selection** — Choose and justify each layer:
   - Frontend framework + rationale
   - Backend framework + rationale
   - Database + rationale
   - Deployment platform + rationale
   - Key libraries (ORM, auth, validation, etc.)

2. **System architecture diagram** — Draw the component layout:
   - Client → API → Services → Data stores
   - External service integrations
   - Authentication flow
   - Use ASCII art or mermaid syntax

3. **API contract design** — Define every endpoint needed for P0 features:
   - HTTP method + path
   - Request body schema (JSON)
   - Response body schema (JSON)
   - Status codes
   - Authentication requirement
   - Group by resource/domain

4. **Database schema design** — Define tables for the data model:
   - Table name, columns, types, constraints
   - Primary and foreign keys
   - Indexes for common queries
   - Migration strategy (numbered, reversible)

5. **Third-party integration plan** — For each external dependency:
   - Service name and purpose
   - Integration method (SDK, API, webhook)
   - Authentication mechanism
   - Rate limits and error handling

6. **Deployment architecture** — How it runs in production:
   - Environment topology (dev/staging/prod)
   - CI/CD pipeline overview
   - Environment variables needed
   - Health checks and monitoring

## Output Template

Write to `docs/workflow/05-system-design.md`:

```markdown
# System Design: [Project Name]

## Tech Stack

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Frontend | [Framework] | [Why] |
| Backend | [Framework] | [Why] |
| Database | [Type + engine] | [Why] |
| Deployment | [Platform] | [Why] |
| Auth | [Solution] | [Why] |
| Key Libraries | [List] | [Purpose each] |

## System Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client     │────>│   API       │────>│  Database   │
│  (Frontend)  │<────│  (Backend)  │<────│             │
└─────────────┘     └──────┬──────┘     └─────────────┘
                          │
                    ┌─────┴──────┐
                    │ External   │
                    │ Services   │
                    └────────────┘
```

[Detailed component descriptions]

## API Contract

### [Resource Group 1]

#### `POST /api/[resource]`
- **Description**: [What it does]
- **Auth**: Required / None
- **Request**:
  ```json
  { "field": "value" }
  ```
- **Response 200**:
  ```json
  { "field": "value" }
  ```
- **Response 400**: `{ "error": "message" }`
- **Response 401**: `{ "error": "Unauthorized" }`

#### `GET /api/[resource]/:id`
[Same structure]

[Continue for all endpoints]

### [Resource Group 2]
[Same structure]

## Database Schema

### [Table: users]
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK, DEFAULT gen_random_uuid() | Primary key |
| email | VARCHAR(255) | UNIQUE, NOT NULL | User email |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation time |

### [Table: [name]]
[Same structure]

### Indexes
```sql
CREATE INDEX idx_[table]_[column] ON [table]([column]);
```

### Relationships
```
users --1:N--> [table]
[table] --N:1--> [table]
```

## Third-Party Integrations

| Service | Purpose | Method | Auth | Rate Limit |
|---------|---------|--------|------|------------|
| [Name] | [What for] | [SDK/API] | [Method] | [Limit] |

## Deployment Architecture

### Environments
- **Development**: [description]
- **Staging**: [description]
- **Production**: [description]

### Environment Variables
| Variable | Description | Required |
|----------|-------------|----------|
| [NAME] | [What it's for] | Yes/No |

### CI/CD Pipeline
[Overview of build, test, deploy steps]

### Health Checks
- `GET /health` — Returns `{ "status": "ok" }`
```

## Self-Check List

- [ ] Every P0 feature from the PRD has at least one API endpoint
- [ ] Every entity in the PRD data model has a corresponding database table
- [ ] API endpoints follow consistent naming (RESTful, plural resources)
- [ ] Database schema includes timestamps (created_at, updated_at)
- [ ] Authentication and authorization are addressed
- [ ] Foreign key relationships are explicit
- [ ] Deployment is described well enough to set up

## Quality Criteria

Good enough when: a developer can scaffold the project and implement endpoints from the contract alone. Not when: API schemas are incomplete or the architecture diagram is missing components.
