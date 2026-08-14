# Module 5 — Jump In

Haven't done Modules 1–4? No problem. This module is self-contained.

---

## Context (2 min read)

The **Jentic API AI Readiness Framework** scores OpenAPI specs across 6 dimensions
that measure how well the spec enables AI agent workflows.

The core question: **a valid spec is not the same as an agent-ready spec.**

The Petstore — the most-referenced OpenAPI example on the internet — scores 68/100 (B+).
Valid? Yes. Agent-ready? Not quite.

---

## Quickest Path (10 min)

1. Install the CLI or use the browser: https://jentic.com/scorecard

2. Get a free API key: https://jentic.com/scorecard?tab=api-keys

3. Score the Petstore (no key required — it's in the public OAK library):

```bash
jentic-api-scorecard score --detail dimensions \
  https://raw.githubusercontent.com/jentic/jentic-public-apis/refs/heads/main/apis/openapi/swagger-api/petstore/1.0.27/openapi.json
```

4. Pick a track:
   - **[Track A](./track-a/README.md)** — score the workshop's Book Catalog API via CLI
   - **[Track B](./track-b/README.md)** — score and compare Spotify, Slack, Shopify, Box, Petstore
   - **[Track C](./track-c/README.md)** — score using the `jentic-api-scorecard` agent skill
   - **[Track D](./track-d/README.md)** — improve a spec using the `jentic-api-improve` agent skill

---

## Jentic AIR Framework at a Glance

| Level | Score | Meaning |
|-------|-------|---------|
| 🟢 ai-ready | 75+ | Ready for autonomous agent workflows |
| 🟡 ai-aware | 65–74 | Usable by agents with some manual guidance |
| 🟠 foundational | 50–64 | Valid but fragile for agent use |
| 🔴 not-ready | <50 | Too many gaps for reliable agent operation |

**Full reference:** [ai-readiness-quick-reference.md](./ai-readiness-quick-reference.md)

---

## Key Insight

The two highest-impact fixes for most real-world APIs:

1. **Add `summary` to every operation** (pushes ARAX from F to C for Slack alone)
2. **Add `application/problem+json` to error responses** (improves ARAX error_standardization)

These two changes take minutes to make but have outsized score impact.
