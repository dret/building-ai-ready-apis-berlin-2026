# Track A — Score the Book Catalog API

**Time:** ~20 minutes  
**Goal:** Score the Book Catalog API we've built through this workshop and understand where it stands on the Jentic AIR Framework.

---

## Setup

Ensure the CLI is installed and working:

```bash
jentic-api-scorecard --version
# or
npx @jentic/api-scorecard-cli@latest --version
```

You need a Jentic API key to score local files. Export it:

```bash
export JENTIC_API_KEY=your-key-here
```

Get a free key (100 scorings/month) at https://jentic.com/scorecard?tab=api-keys.  
If you don't have a key, use the browser scorer at **https://jentic.com/scorecard** and drag-and-drop the file.

---

## Part 1 — Baseline Score (5 min)

Score the Book Catalog API with a full signal breakdown:

```bash
jentic-api-scorecard score --detail signals book-catalog-governed.openapi.yaml
```

Note down:
- Overall score and grade
- The weakest dimension (lowest %)
- The weakest signal within that dimension

---

## Part 2 — Diagnostic Deep Dive (10 min)

Run diagnostics to get evidence for each failure:

```bash
jentic-api-scorecard score --detail diagnostics book-catalog-governed.openapi.yaml
```

Answer these questions from the output:

1. **FC (Foundational Compliance)** — Does the spec pass schema validation? Any broken references?

2. **DX (Developer Experience)** — What fraction of operations have summaries? Do the examples in the spec pass validation?

3. **ARAX (Agent Readiness)** — Are the operation descriptions agent-friendly? Do they explain *when* to call this operation vs. similar ones?

4. **AU (Agent Usability)** — Are all operations tagged? Are responses linked to related resources?

5. **SEC (Security)** — Is the Bearer token scheme well documented? Is security applied consistently?

6. **AID (AI Discoverability)** — Does `info.description` explain the API well enough for an agent to choose it over alternatives?

---

## Part 3 — Reflection (5 min)

Discuss with your neighbour or note down:

1. **What did you expect vs. what did you get?**  
   This spec was designed from the start to be AI-ready. Did the score reflect that?

2. **Which dimension would you improve first?**  
   Pick the weakest dimension and identify the single highest-impact change.

3. **What does this tell you about designing APIs for agents?**  
   Is a syntactically valid spec enough? What's still missing?

---

## Compare with the Improved Version

After completing this track, look at the reference solution in
`../../../solutions/module-5/book-catalog-improved.openapi.yaml` and re-score it:

```bash
jentic-api-scorecard score --detail dimensions \
  ../../../solutions/module-5/book-catalog-improved.openapi.yaml
```

What changed? What moved the score?
