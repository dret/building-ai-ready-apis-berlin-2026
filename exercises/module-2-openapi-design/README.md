# Module 2: Designing Governed API Specifications with OpenAPI

**Duration:** ~30 minutes  
**Owner:** Erik Wilde  / Frank

## Objective

Design a well-structured, AI-ready OpenAPI 3.1.2 specification for the **Book Catalog API** — a public catalog with reading list management. You will generate or complete a spec, validate it, and lint it against governance rules.

This exercise condenses three steps into one flow: **Generate → Validate → Lint**.

---

## The API You're Designing

The Book Catalog API exposes:
- Public endpoints for searching/browsing books and authors
- Retailer lookup (where to buy a specific book)
- Authenticated reading list management

Full story and domain model: [`user-story.md`](./user-story.md)

---

## Part A — Generate or Complete (15 min)

Choose one option:

### Option 1: LLM-Assisted Generation
1. Open `system-prompts/openapi-design-assistant.md` — this is your system prompt
2. Open a new chat with your LLM of choice (ChatGPT, Claude, Gemini, etc.)
3. Set the system prompt (or paste it at the top of your message)
4. Send the contents of `user-story.md` as your prompt
5. Copy the generated YAML into a file called `book-catalog.openapi.yaml`

> **Tip:** If the output is incomplete, prompt: *"Continue the spec from where you left off, starting with the remaining paths"*

### Option 2: Complete the Skeleton
1. Open `book-catalog-skeleton.openapi.yaml`
2. Replace every `# TODO` marker with proper content
3. Use `user-story.md` and `system-prompts/openapi-design-assistant.md` for guidance
4. Save as `book-catalog.openapi.yaml`

### Option 3: Claude Code Agent Skill
If you're using Claude Code:
```
Design a Book Catalog API using the user story in exercises/module-2-openapi-design/user-story.md
and the design guidelines in exercises/module-2-openapi-design/system-prompts/openapi-design-assistant.md.
Generate a complete OpenAPI 3.1.2 YAML spec.
```

---

## Part B — Validate (10 min)

Check that your spec is structurally valid before linting.

**Option 1: Swagger Editor (browser)**
1. Go to [editor.swagger.io](https://editor.swagger.io)
2. Paste your YAML
3. Fix validation errors shown on the right panel (or at the bottom)

**Option 2: Scalar Editor (browser)**
1. Go to [editor.scalar.com](https://editor.scalar.com/)
2. Paste your YAML
3. Fix validation errors shown in the diagnostics panel

**Option 3: VS Code with Redocly extension**
1. Install the **Redocly OpenAPI** extension from the VS Code marketplace
2. Open your YAML file — errors appear inline in the editor


Common issues to watch for:
- Missing `$ref` targets (schema referenced but not defined in components)
- Duplicate `operationId` values
- Invalid `type` combinations (e.g., `nullable: true` is not valid in OpenAPI 3.1)

---

## Part C — Lint (10 min)

Run Spectral with the workshop ruleset to check governance compliance.

### Install Spectral (if not already installed)
```bash
npm install -g @stoplight/spectral-cli
```

### Run the linter

> Note: if you did part B in Scalar, then you can copy the contents of `.spectral.yaml` into the Diagnostics tab

```bash
spectral lint book-catalog.openapi.yaml --ruleset .spectral.yaml
```

There are two rulesets in this module:

**`.spectral.yaml`** — minimal ruleset, safe to run on any spec type (OAS, Arazzo, AsyncAPI):
```bash
spectral lint book-catalog.openapi.yaml --ruleset .spectral.yaml
```
> Note: if you did part B in Scalar, then you can copy the contents of `custom-ruleset.spectral.yaml` into the Diagnostics tab

**`custom-ruleset.spectral.yaml`** — extends the minimal ruleset with governance rules:
```bash
spectral lint book-catalog.openapi.yaml --ruleset custom-ruleset.spectral.yaml
```

Start with `.spectral.yaml` to catch structural errors first — these are blockers. Once structural errors are clear, run `custom-ruleset.spectral.yaml` for the full governance check.

### What the custom rules check
| Rule | Severity | What it enforces |
|------|----------|-----------------|
| `oas3-schema` | error | Valid OpenAPI 3.1.2 structure |
| `operation-description-required` | error | Every operation has an agent-ready description |
| `operation-summary-required` | error | Every operation has a summary |
| `operation-operationId-required` | error | Every operation has a unique operationId |
| `schema-property-description` | warn | Every schema property has a description |
| `schema-description` | warn | Every component schema has a description |
| `info-contact` | warn | API info has contact details |
| `operation-4xx-response` | warn | Operations document error responses |

### Fix all errors before moving on
Warnings are important for AI-readiness but errors are blockers. Aim to clear errors first, then address warnings.

### Optional: Quick pre-score
If you want to see your AI-readiness score before the Module 5 deep-dive:

Head to [https://jentic.com/scorecard](https://jentic.com/scorecard), and drop in your OpenAPI YAML file.

---

## What Good Looks Like

A well-completed spec will have:
- ✅ No Spectral errors
- ✅ Every operation has a description that answers: what it does, what inputs matter, what it returns
- ✅ All schemas in `components/schemas` — no inline schemas
- ✅ RFC 9457 Problem Details (`application/problem+json`) for all error responses — see [jentic/api-problem-details](https://github.com/jentic/api-problem-details) for the canonical reusable components
- ✅ `data`/`meta` wrapper on all collection responses
- ✅ Decimal strings with currency for monetary amounts
- ✅ Bearer JWT security scheme on reading list endpoints

---

## Reference Solution

If you get stuck or want to compare: [`../../solutions/module-2/book-catalog.openapi.yaml`](../../solutions/module-2/book-catalog.openapi.yaml)

Try to complete the exercise first — the solution is most valuable as a comparison, not a shortcut.

---

## Moving On

Your `book-catalog.openapi.yaml` feeds directly into **Module 3**, where you'll apply governance policies to it using OpenAPI Overlay — without modifying this file.
