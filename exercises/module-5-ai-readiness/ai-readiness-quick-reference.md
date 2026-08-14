# Jentic AIR Framework Quick Reference

**Jentic API AI Readiness Framework** — 6 dimensions, 0–100 score.

---

## Score Levels

| Score | Grade | Level | Meaning |
|-------|-------|-------|---------|
| 75–100 | A | 🟢 ai-ready | Ready for autonomous agent workflows |
| 65–74 | B | 🟡 ai-aware | Usable by agents with manual intervention |
| 50–64 | C | 🟠 foundational | Baseline compliance; agent usage is fragile |
| 0–49 | D/F | 🔴 not-ready | Significant gaps prevent reliable agent usage |

---

## The 6 Dimensions

### FC — Foundational Compliance
*Is the spec technically valid and structurally sound?*

Key signals:
- `spec_validity` — passes OpenAPI schema validation (no broken `$ref`, missing required fields, type errors)
- `structural_integrity` — all referenced schemas and components resolve correctly
- `version_compliance` — spec is a supported OpenAPI version

**Fix:** Run through a validator (Spectral, Redocly, editor.swagger.io). Every error here costs heavily because FC is a prerequisite for the other dimensions.

---

### DX — Developer Experience
*Can a developer understand and use this API quickly?*

Key signals:
- `description_coverage` — fraction of operations, parameters, and schema properties with descriptions
- `summary_coverage` — fraction of operations with a `summary` field
- `example_density` — fraction of schemas/operations with examples
- `example_validity` — fraction of examples that pass schema validation
- `response_coverage` — fraction of operations with 4xx and 5xx responses defined

**Fix:** Add summaries (single-phrase imperative verb) to all operations. Add `example` fields to request/response schemas. Add `400` and `500` responses to all endpoints.

---

### ARAX — Agent Readiness & Agent Experience
*Can an AI agent understand and chain this API's operations safely?*

Key signals:
- `description_quality` — descriptions answer: what it does, what inputs mean, what outputs mean, what errors to expect, when to call it vs similar operations
- `error_standardization` — error responses use a consistent, machine-readable format (RFC 9457 Problem Details preferred)
- `operation_disambiguation` — operations with similar names are clearly differentiated in descriptions

**Fix:** Write descriptions in imperative form. Ensure error responses use `application/problem+json` with a `type` URI. Distinguish `createOrder` vs `updateOrder` clearly in their descriptions.

---

### AU — Agent Usability
*Can an agent navigate this API at scale without getting lost?*

Key signals:
- `operation_count` — very large APIs (200+ operations) score lower here unless well-tagged
- `tag_coverage` — operations are tagged for logical grouping
- `navigation_links` — responses include links (OpenAPI `links` or `_links`) to related resources
- `pagination_consistency` — collection responses use consistent pagination patterns

**Fix:** Tag all operations. For large APIs, ensure every operation is in exactly one tag group. Add OpenAPI `links` to single-resource responses (e.g., a `Book` response that links to its `Author`).

---

### SEC — Security
*Is authentication documented and consistently applied?*

Key signals:
- `security_scheme_defined` — at least one security scheme is defined in `components/securitySchemes`
- `security_applied` — security is applied to all operations that need it (not just defined globally)
- `credential_safety` — credentials are not passed in query parameters or request bodies
- `scheme_documentation` — security schemes have descriptions explaining how to obtain and use tokens

**Fix:** Define security schemes with full descriptions. Apply `security` explicitly at the operation level for write endpoints. Never put API keys in query parameters.

---

### AID — AI Discoverability
*Can an AI agent discover and understand what this API does from its metadata?*

Key signals:
- `info_description` — `info.description` is present and explains what the API does and who it's for
- `tag_descriptions` — tags have `description` fields explaining what each group covers
- `server_descriptions` — server entries have `description` fields distinguishing environments
- `contact_present` — `info.contact` is present so agents and developers know where to get help
- `x_ai_extensions` — presence of `x-ai-*` extensions providing agent-specific guidance

**Fix:** Write a rich `info.description`. Add descriptions to tags and server entries. Add `x-agent-hint` to operations with side effects or non-obvious behaviour. Add `x-mcp-tool-name` to give MCP clients stable, machine-friendly tool names.

---

## Reference Scores — Workshop Sample APIs

| API | Score | FC | DX | ARAX | AU | SEC | AID |
|-----|-------|----|----|------|----|-----|-----|
| Spotify Web API | 75.1 (A-) 🟢 | 99% | — | 54% | — | 90% | 100% |
| Box Platform API | 68.8 (B+) 🟡 | — | — | 80% | 43% | — | — |
| Swagger Petstore v3 | 68.6 (B+) 🟡 | 99.5% | — | 55% | — | 43% | — |
| Shopify REST Admin | 58.2 (C+) 🟠 | ✗ | — | — | — | — | — |
| Slack Web API | 51.3 (C-) 🟠 | — | — | 27.5% | — | — | — |

*Note: Slack's `summary_coverage` is 0.00 — not one of 169 operations has a `summary` field. This single gap drags ARAX to F.*

---

## Diagnostic Workflow

```bash
# Step 1: headline grade
jentic-api-scorecard score --detail summary my-api.yaml

# Step 2: find the weakest dimension
jentic-api-scorecard score --detail dimensions my-api.yaml

# Step 3: identify specific failing signals
jentic-api-scorecard score --detail signals my-api.yaml

# Step 4: get evidence for each failure
jentic-api-scorecard score --detail diagnostics my-api.yaml
```

Start fixing from the lowest-scoring dimension that is easiest to address. FC failures block all other dimensions — fix those first.
