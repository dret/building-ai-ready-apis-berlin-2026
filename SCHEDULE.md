# Workshop Schedule
## Building AI-Ready APIs with Agent Skills
### API Days India — August 21, 2026

**Format:** Full-day masterclass (8 hours)  
**Presenters:** Frank Kilcommins, Erik Wilde


## Overview

| Time | Module | Owner | Type |
|------|--------|-------|------|
| 09:30 | Opening & Welcome | Both | Presentation |
| 10:00 | Module 1: Understanding AI-Driven API Usage | Erik | Exercise |
| 10:35 | Agent Skills — Introduction | Both | Presentation |
| 11:00 | Module 2: Designing with OpenAPI | Erik | Exercise |
| 11:40 | Break | — | — |
| 11:55 | Module 3: Overlay Governance | Frank | Exercise |
| 12:40 | Lunch | — | — |
| 13:30 | Module 4: Arazzo Workflows | Frank | Exercise |
| 14:25 | Break | — | — |
| 14:40 | Module 5: AI-Ready Ecosystems | Frank | Exercise |
| 16:15–16:45 | From API Specification to Implementation| Erik |
| 16:45–17:30 | Wrap-up / Takeaways / Q&A / Open Discussion | Both |
| 17:30 | End | — | — |


## Detailed Schedule

### 09:30 — Opening & Welcome (30 min)

- Welcome and introductions (5 min)
- Workshop goals and structure (5 min)
- **"Why AI Changes API Design"** — the central thesis (15 min)
  - From human-readable to machine-operable
  - The agent interaction model: goals → API calls → results
  - What the Jentic AIR Framework measures and why it matters
- Quick logistics: tools, repo, jump-in option (5 min)


### 10:00 — Module 1: Understanding AI-Driven API Usage (35 min)

**Owner:** Erik  
**Format:** Presentation + Exercise

- **Presentation:** API governance for AI consumers (10 min)
  - What an agent sees when it reads an OpenAPI spec
  - Common failure modes: ambiguity, missing errors, credential exposure
- **Exercise:** "Map the Risk" worksheet (15 min)
  - Participants analyze `book-catalog-raw.openapi.yaml`
  - Identify ambiguity, unintended workflows, governance gaps
- **Debrief:** Group discussion of findings (10 min)
  - What surprised people most?
  - Which issues are hardest to fix retroactively?

*Jump-in: `exercises/module-1-ai-usage/JUMP-IN.md`*


### 10:35 — Agent Skills Introduction (25 min)

**Owner:** Both  
**Format:** Presentation + live demo

Shared mental model before agent skills start appearing in exercises:

- What is an agent skill? (extending Claude Code via SKILL.md) (3 min)
- How skills are installed and invoked (3 min)
- The four skills used today and which modules they appear in (3 min)
- Skills vs. CLI — when to use which (3 min)
- **Live demo:** invoking `jentic-api-scorecard` skill end-to-end (8 min)
- What the skill knows without being told (the SKILL.md contract) (3 min)
- Today's agenda — where you'll encounter each skill (2 min)


### 11:00 — Module 2: Designing Governed API Specifications (40 min)

**Owner:** Erik  
**Format:** Presentation + Exercise

- **Presentation:** OpenAPI design principles for agent consumers (10 min)
  - The paraskakis standards: naming, structure, descriptions, errors
  - How Spectral enforces governance at design time
- **Exercise — 3 parts:**
  - Part A: Generate a Book Catalog spec using LLM + system prompt (15 min)
  - Part B: Validate in Swagger Editor (5 min)
  - Part C: Lint with Spectral and fix issues (10 min)

*Jump-in: `exercises/module-2-openapi-design/JUMP-IN.md`*


### 11:40 — Break (15 min)


### 11:55 — Module 3: Applying Governance with OpenAPI Overlay (45 min)

**Owner:** Frank  
**Format:** Presentation + Exercise

- **Presentation:** What is OpenAPI Overlay and why does it exist? (10 min)
  - Separation of concerns: spec vs. governance
  - Non-destructive overlay application
  - Where overlays fit in a governance pipeline
- **Exercise:** "Governance Without Touching the Source" (30 min)
  - Overlay 1: Remove internal admin endpoints
  - Overlay 2: Standardize contact and license
  - Overlay 3: Enforce security on write operations
  - Bonus: Add `x-mcp-tool-name` and `x-agent-hint` to reading list operations
- **Validation:** Run result through Spectral (5 min)

*Jump-in: `exercises/module-3-overlay/JUMP-IN.md`*

### 12:40 — Lunch (60 min)


### 13:30 — Module 4: Modeling API Workflows with Arazzo (55 min)

**Owner:** Frank  
**Format:** Presentation + Exercise

- **Presentation:** From individual operations to workflows (10 min)
  - Why OpenAPI alone isn't enough for multi-step workflows
  - Arazzo 1.0.1: sourceDescriptions, workflows, steps, successCriteria
  - Data flow with runtime expressions
- **Exercise:** "Describe the Workflow Before the Agent Guesses It" (35 min)
  - Generate an Arazzo spec using Arazzo GPT or `jentic-workflows` skill
  - Validate with `spectral:arazzo`
  - Add success criteria, failure actions, auth headers
- **Review:** Key design decisions discussed (10 min)
  - Why `processPayment` needs a body check, not just a status check
  - How failure actions prevent runaway workflows

*Jump-in: `exercises/module-4-arazzo/JUMP-IN.md`*


### 14:25 — Break (15 min)



### 14:40 — Module 5: Designing AI-Ready API Ecosystems (80 min)

**Owner:** Frank  
**Format:** Presentation + Exercise

- **Presentation:** The Jentic AIR Framework — measuring agent readiness (10 min)
  - 6 dimensions: FC, DX, ARAX, AU, SEC, AID
  - The Petstore paradox: valid ≠ ready
  - Where real-world APIs fall short
- **Parallel tracks (choose one):**
  - **Track A:** Score our Book Catalog API via CLI (20 min)
  - **Track B:** Score and compare real-world APIs via CLI (25 min)
  - **Track C:** Score using the `jentic-api-scorecard` agent skill (20 min)
  - **Track D:** Improve a spec with the `jentic-api-improve` skill (30 min)
- **Plenary debrief:** What patterns emerged? (15 min)
  - Surprising scores, surprising gaps
  - The ROI story: 2 changes that have outsized impact

*Jump-in: `exercises/module-5-ai-readiness/JUMP-IN.md`*


### 16:15 — From API Specification to Implementation (30 min)

**Owner:** Erik  
**Format:** Presentation

- From spec to running API — the implementation pipeline (10 min)
  - Code generation from OpenAPI: strengths and limits
  - Contract-first vs. code-first trade-offs
  - How a well-governed spec reduces implementation ambiguity
- Agent skills in the implementation loop (10 min)
  - Using skills to validate, score, and improve specs before generation
  - Continuous governance: spec → overlay → governed spec → implementation
- What this means for the provider side (10 min)
  - Tooling landscape: generators, mocking, testing from spec
  - The governance feedback loop: score → improve → re-score


### 16:45 — Wrap-up / Takeaways / Q&A / Open Discussion (45 min)

**Owner:** Both  
**Format:** Presentation + open discussion

- **Key takeaways** (10 min)
  - The five things that most move the needle on API agent-readiness
  - The role of standards (Arazzo, Overlay, Jentic AIR Framework) in scaling governance
  - Agent skills as force multipliers: what they automate vs. what they can't
- **What to do on Monday** — 3 concrete actions (5 min)
  - Score your most-used API with `jentic-api-scorecard`
  - Add summaries to all operations lacking one
  - Write one Arazzo workflow for your most common multi-step consumer flow
- **Resources** (5 min)
  - Jentic API AI Readiness Framework specification: https://docs.jentic.com/reference/api-readiness-framework/specification/
  - Arazzo 1.1.0: https://spec.openapis.org/arazzo/latest.html
  - OpenAPI Overlay: https://spec.openapis.org/overlay/latest.html
  - This repository
- **Q&A / Open Discussion** (25 min) — presenters available for questions, tool demos, and one-on-ones


## Jump-In Note

Participants arriving late or needing to restart can join at any module boundary.
Each module's `JUMP-IN.md` provides 2-minute context and the exact starting files.
See `JUMP-IN-GUIDE.md` for the master jump-in reference.
