# Workshop Plan: Building AI-Ready APIs with Agent Skills
## API Days India, August 21, 2026

This document is the working plan for designing, building, and sequencing all exercises and supporting materials for the masterclass.

---

## 1. What We're Building

Six module exercises (plus a new agent skills intro module) that:
- Build progressively on a single running API scenario
- Are individually self-contained (jump-in starter files per module)
- Integrate agent skills (Claude Code + Jentic) as first-class tools
- Replace Itarazzo with Jentic Arazzo tooling + Arazzo GPT
- Condense Paris 2025 Exercises 1-3 into a single richer exercise

---

## 2. Running Scenario

All exercises use the **Book Platform** — a multi-service API ecosystem for discovering, purchasing, and reading books. It starts simple (one API) and expands across modules.

| Module | APIs in scope |
|--------|--------------|
| 1 | `book-catalog.openapi.yaml` (pre-provided, intentionally raw/incomplete) |
| 2 | `book-catalog.openapi.yaml` (design from scratch or improve) |
| 3 | `book-catalog.openapi.yaml` (govern with Overlay) |
| 4 | `book-catalog.openapi.yaml` + `book-orders.openapi.yaml` (multi-API Arazzo workflow) |
| 5 | Book Platform APIs + real-world public APIs (score and improve with agent skills) |

This keeps the domain familiar throughout. Attendees always know what they're working with.

---

## 3. Source Material Mapping

| Source | Used for |
|--------|---------|
| Paris 2025 Exercises 1-3 | Module 2 (condensed into one multi-part exercise) |
| Paris 2025 Exercise 5 | Module 3 (Overlay — extended with more governance rules) |
| APIOps-AI-Ready-APIs | Module 5 (scoring + improvement with agent skills) |
| describing-api-workflows-with-arazzo | Module 4 structure (BNPL → Book Platform scenario; Arazzo GPT stays; Itarazzo replaced by Jentic tooling) |
| india.xml presentation slides | Content alignment for all modules |

---

## 4. Module Exercises

### Agent Skills — Brief Presentation Module + Woven Into Exercises

A **7-slide presentation module** (~10 min) introduces agent skills before they appear
in exercises. No hands-on component — the goal is to establish a shared mental model:
what skills are, how they extend Claude Code, how to invoke them, and what attendees
will use them for during the day.

Suggested placement: after Module 1 debrief, before Module 2 starts.

Slide outline (7 slides):
1. What is an agent skill? (extending Claude Code's capabilities)
2. How skills are installed and invoked (`/plugin install`, `/skill-name`)
3. The four skills used in this workshop (scorecard, improve, workflows, design-assistant)
4. Skills vs. CLI: when to use which (interactive vs. scripted)
5. Live demo — 60-second `jentic-api-scorecard` skill invocation
6. What the skill knows that you don't have to tell it (the SKILL.md contract)
7. Skills appear in Modules 2, 4, and 5 — today's agenda

Each exercise README documents which tool options are available (Claude Code skill,
CLI, or web UI fallback) so attendees can choose their preferred path.

Skills used across exercises:
- `jentic-api-scorecard` — score any OpenAPI spec (Modules 2 and 5 — Tracks A, B, C)
- `jentic-api-improve` — iteratively improve a spec based on Jentic AIR Framework diagnostics (Module 5 — Track D)
- `jentic-workflows` — generate Arazzo from natural language goal (Module 4 option)
- Arazzo GPT — alternative to `jentic-workflows` for Arazzo generation (Module 4 option)
- A workshop-local `api-design-assistant` skill concept is included in Module 2 as a SKILL.md

---

### Module 1 Exercise: Understanding AI-Driven API Usage
**Owner:** Erik  
**Duration:** ~25 min  
**Builds on:** Slides about AI agent interaction patterns and governance risks

Exercise: **"Map the Risk"**  
Given a raw, incomplete `book-catalog.openapi.yaml`, participants:
1. Read through the spec and identify: what can an AI agent do with this API?
2. Complete a structured worksheet identifying:
   - Which endpoints are ambiguous (no description, unclear params)
   - Where an agent could trigger unintended workflows
   - What missing information creates security or safety gaps
3. Discuss findings as a group (plenary debrief)

This exercise is deliberately analytical (no tooling required) and sets the motivation for Modules 2–5.

Jump-in condition: Self-contained — the worksheet and spec are fully provided.

Deliverables to create:
- `exercises/module-1-ai-usage/README.md` — exercise instructions
- `exercises/module-1-ai-usage/book-catalog-raw.openapi.yaml` — intentionally incomplete spec (no descriptions, inconsistent naming, missing error responses, no security)
- `exercises/module-1-ai-usage/risk-mapping-worksheet.md` — structured worksheet with prompts
- `exercises/module-1-ai-usage/JUMP-IN.md` — 2-minute context for late arrivals

---

### Module 2 Exercise: Designing Governed API Specifications with OpenAPI
**Owner:** Erik  
**Duration:** ~45 min  
**Builds on:** Module 1 findings (the same spec, now improved)

Condensed from Paris 2025 Exercises 1 + 2 + 3 into three parts:

**Part A — Generate (15 min)**  
Use an LLM with the provided system prompt to generate (or substantially improve) the `book-catalog.openapi.yaml` based on a user story.
- User story: Book catalog with search, detail retrieval, and purchase entry points
- System prompt: adapted from Paris 2025 `openapi-creation-or-modification.md` (updated for OpenAPI 3.1.2, Book Platform domain, AI-readiness intent)
- Alternative: Complete a provided skeleton spec manually

**Part B — Validate (10 min)**  
Paste the generated/improved spec into Scalar or Swagger Editor. Fix any structural errors until valid.

**Part C — Lint (20 min)**  
Run Spectral against the spec using the provided ruleset.
- Ruleset: adapted from Paris 2025 `.spectral.yaml`, extended with Agent Experience rules (operationId required, summary required, RFC 9457 errors)
- Fix all reported issues
- Optionally: use `jentic-api-scorecard` agent skill to get a quick pre-score

Jump-in condition: Provided skeleton spec + system prompt. Reference solution provided.

Deliverables to create:
- `exercises/module-2-openapi-design/README.md` — instructions for all three parts
- `exercises/module-2-openapi-design/user-story.md` — Book Platform user story
- `exercises/module-2-openapi-design/system-prompts/openapi-creation-or-modification.md` — adapted from Paris
- `exercises/module-2-openapi-design/book-catalog-skeleton.openapi.yaml` — starter file
- `exercises/module-2-openapi-design/.spectral.yaml` — linting ruleset (extended)
- `exercises/module-2-openapi-design/JUMP-IN.md` — context + reference solution pointer
- `solutions/module-2/book-catalog.openapi.yaml` — reference solution

---

### Module 3 Exercise: Applying Governance with OpenAPI Overlay
**Owner:** Frank  
**Duration:** ~35 min  
**Builds on:** Module 2 output (or reference solution)

Exercise: **"Governance Without Touching the Source"**  
Apply an Overlay to the Book Catalog API that enforces governance policies without modifying the original spec.

Tasks:
1. **Overlay 1 — Audience targeting**: Remove internal-only admin endpoints from the public-facing spec
2. **Overlay 2 — Contact and license governance**: Replace/standardize contact info and add license
3. **Overlay 3 — Security enforcement**: Add security requirements to all write operations that don't have them
4. **Bonus**: Add `x-mcp-tool-name` and `x-agent-hint` extensions to reading list operations for MCP tool metadata

Tools: Speakeasy Overlay Playground (web, no install) or Overlay CLI  
Validation: Run the result through Spectral to confirm governance is applied correctly

Jump-in condition: Reference solution from Module 2 provided as starter. Each overlay task is independently completable.

Deliverables to create:
- `exercises/module-3-overlay/README.md` — instructions for all overlay tasks
- `exercises/module-3-overlay/book-catalog-reference.openapi.yaml` — copy of Module 2 reference solution (jump-in starter)
- `exercises/module-3-overlay/governance-policies.md` — description of the policies to enforce
- `exercises/module-3-overlay/book-catalog-internal.openapi.yaml` — version with internal endpoints (for task 1)
- `exercises/module-3-overlay/JUMP-IN.md`
- `solutions/module-3/audience-targeting.overlay.yaml`
- `solutions/module-3/contact-license.overlay.yaml`
- `solutions/module-3/security-enforcement.overlay.yaml`
- `solutions/module-3/book-catalog-governed.openapi.yaml` — final governed spec

---

### Module 4 Exercise: Modeling API Workflows with Arazzo
**Owner:** Frank  
**Duration:** ~45 min  
**Builds on:** Module 3 output (the governed Book Catalog API) + a new Book Orders API

Exercise: **"Describe the Workflow Before the Agent Guesses It"**  
Model a multi-step workflow: a customer discovers a book, checks availability, and completes a purchase.

Two APIs in scope:
- `book-catalog.openapi.yaml` — search, browse, get details
- `book-orders.openapi.yaml` — check availability, place order, confirm order (pre-provided)

Steps:
1. **Generate with Arazzo GPT**: Provide both OpenAPI URLs + a natural language workflow description → get initial Arazzo YAML
2. **Validate with Spectral**: Use `spectral:arazzo` ruleset to lint the generated spec, fix issues
3. **Enrich**: Add meaningful `successCriteria`, `failureActions`, and `outputs` to make the workflow deterministic
4. **Review with Jentic tooling**: Use Jentic's Arazzo support (not Itarazzo) to inspect and validate the workflow

Jump-in condition: Both OpenAPI specs + workflow requirements doc provided. Participants can start from the GPT generation step without doing earlier modules.

Deliverables to create:
- `exercises/module-4-arazzo/README.md` — instructions
- `exercises/module-4-arazzo/book-catalog-governed.openapi.yaml` — copy of Module 3 reference solution
- `exercises/module-4-arazzo/book-orders.openapi.yaml` — new spec to create (availability, order, confirmation endpoints)
- `exercises/module-4-arazzo/workflow-requirements.md` — natural language description of the 3-step workflow for the GPT prompt
- `exercises/module-4-arazzo/.spectral.yaml` — ruleset extending `spectral:arazzo`
- `exercises/module-4-arazzo/arazzo-gpt-prompt.md` — suggested prompt for Arazzo GPT
- `exercises/module-4-arazzo/JUMP-IN.md`
- `solutions/module-4/book-platform.arazzo.yaml` — reference solution

---

### Module 5 Exercise: Designing AI-Ready API Ecosystems
**Owner:** Frank  
**Duration:** ~60 min (can run in parallel tracks)  
**Builds on:** All previous modules; introduces agent skills as core tooling

Exercise: **"Measure, Diagnose, Improve"**  

Four tracks (participants choose based on interest/time):

**Track A — Score Your Workshop API via CLI (15 min)**  
Score the Book Catalog API from Module 2/3 directly from the terminal:
- `jentic-api-scorecard score --detail dimensions book-catalog-governed.openapi.yaml`
- Review all 6 Jentic AIR Framework dimensions, identify weakest areas
- Compare with the reference improved spec

**Track B — Score Real-World APIs via CLI (25 min)**  
Using provided sample files (Slack, Shopify, Spotify, Box, Petstore):
- Score all five and fill in the comparison table
- Deep-dive on Slack (ARAX = F) and Spotify (best in set)
- Discuss: what's the cost of a low ARAX (Agent Experience) score?

**Track C — Score Using the Agent Skill (20 min)**  
Use the `jentic-api-scorecard` Claude Code skill to score the Book Catalog API:
- Invoke the skill, let Claude run the scorecard and interpret the results
- Ask follow-up questions in natural language ("Why did ARAX score poorly?")
- Compare: how does the agent's interpretation differ from reading raw CLI output?
- Explore: what can the agent suggest that the CLI output alone doesn't tell you?

**Track D — Improve Using the Agent Skill (30 min)**  
Use the `jentic-api-improve` Claude Code skill to iteratively improve a spec:
- Invoke the skill, target the weakest dimension
- Watch the skill run diagnostics, propose changes, apply them, and re-score
- Target: improve weakest dimension score by at least 10 percentage points
- Optional: try improving the Slack spec (C- → B, one signal change)

All tracks conclude with a plenary: what patterns emerged? What's the ROI story?

Jump-in condition: All needed files (sample APIs, CLI instructions, agent skill setup) are fully self-contained.

Deliverables to create:
- `exercises/module-5-ai-readiness/README.md` — instructions for all three tracks
- `exercises/module-5-ai-readiness/track-a/` — Book Catalog API + scoring instructions
- `exercises/module-5-ai-readiness/track-b/` — sample real-world APIs (Slack, Shopify, Spotify, Petstore copies from APIOps repo)
- `exercises/module-5-ai-readiness/track-c/` — improvement guide + agent skill instructions
- `exercises/module-5-ai-readiness/JUMP-IN.md`
- `exercises/module-5-ai-readiness/jairf-quick-reference.md` — cheat sheet of 6 dimensions + highest-impact fixes per dimension

---

## 5. Cross-Cutting Files

| File | Purpose |
|------|---------|
| `setup/prerequisites.md` | Tool setup for all modules (Node.js, Claude Code, Jentic CLI, Spectral CLI, Arazzo GPT access) |
| `setup/quick-install.sh` | Shell script to verify prerequisites are met |
| `SCHEDULE.md` | Timing for each module with buffer allocation |
| `JUMP-IN-GUIDE.md` | Master guide: how to jump in at any module with the right files |

---

## 6. Jump-In Architecture

Every module is self-contained via:
1. **Starter files**: The reference solution from the previous module is copied in as the jump-in starter
2. **JUMP-IN.md**: 2-3 minute read — what the module needs, what files to use, no prior context required
3. **Solutions folder**: Full reference solutions for every exercise task

```
solutions/
├── module-1/
│   └── risk-mapping-completed.md
├── module-2/
│   └── book-catalog.openapi.yaml
├── module-3/
│   ├── audience-targeting.overlay.yaml
│   ├── contact-license.overlay.yaml
│   ├── security-enforcement.overlay.yaml
│   └── book-catalog-governed.openapi.yaml
├── module-4/
│   └── book-platform.arazzo.yaml
└── module-5/
    ├── book-catalog-improved.openapi.yaml
    └── improvement-summary.md
```

---

## 7. Work Breakdown — What Needs to Be Created

### New content (no prior source)
- `exercises/module-0-agent-skills/` — entirely new
- `exercises/module-4-arazzo/book-orders.openapi.yaml` — new API spec
- `exercises/module-1-ai-usage/book-catalog-raw.openapi.yaml` — intentionally incomplete spec
- `exercises/module-1-ai-usage/risk-mapping-worksheet.md` — new worksheet
- All `JUMP-IN.md` files

### Adapted from Paris 2025
- `exercises/module-2-openapi-design/system-prompts/openapi-creation-or-modification.md` — update for Book Platform domain + OpenAPI 3.1.2
- `exercises/module-2-openapi-design/user-story.md` — replace NYT books story with Book Platform story
- `exercises/module-2-openapi-design/book-catalog-skeleton.openapi.yaml` — replace Paris skeleton
- `exercises/module-2-openapi-design/.spectral.yaml` — extend Paris ruleset with ARAX rules
- `exercises/module-3-overlay/` — extend Paris Exercise 5 with more governance tasks

### Adapted from APIOps-AI-Ready-APIs
- `exercises/module-5-ai-readiness/track-b/` — copy sample APIs (Petstore, Spotify, Slack, Shopify)
- `exercises/module-5-ai-readiness/jairf-quick-reference.md` — distill from APIOps README

### Adapted from describing-api-workflows-with-arazzo
- `exercises/module-4-arazzo/` structure and flow (step-by-step Arazzo design process)
- Replace BNPL domain → Book Platform
- Replace Itarazzo → Jentic Arazzo tooling
- Retain Arazzo GPT + Spectral validation steps

### Schedule and logistics
- `SCHEDULE.md`
- `setup/prerequisites.md`
- `JUMP-IN-GUIDE.md`

---

## 8. Suggested Build Order

1. `setup/prerequisites.md` — needed first so we can test as we build
2. Book Platform API specs (`book-catalog-raw.openapi.yaml`, `book-catalog-skeleton.openapi.yaml`, `book-orders.openapi.yaml`)
3. Module 2 exercise (condensed Paris 1-3) + reference solution
4. Module 3 exercise (Overlay) + reference solution
5. Module 4 exercise (Arazzo) + reference solution
6. Module 5 exercise (AI-readiness + agent skills) + reference solutions
7. Module 1 exercise (risk mapping worksheet — needs finished spec to draw from)
8. Agent skills presentation slides (depends on knowing which skills are used in Modules 2, 4, 5)
9. `SCHEDULE.md`, `JUMP-IN-GUIDE.md`, per-module `JUMP-IN.md` files
