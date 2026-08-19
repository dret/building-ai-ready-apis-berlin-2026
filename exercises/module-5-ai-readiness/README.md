# Module 5 — AI-Ready API Ecosystems

**Duration:** ~30 minutes  
**Builds on:** Module 4 (or use any OpenAPI description you have)  
**Jump in?** See [JUMP-IN.md](./JUMP-IN.md)

---

## Overview

You've designed a well-structured API. But how does it actually perform when an
AI agent tries to use it?

This module introduces the **Jentic API AI Readiness Framework** — a
6-dimension scoring system that measures how well an OpenAPI spec enables autonomous
agent workflows. You'll score real APIs, discover where the gaps are, and use an
agent skill to fix them.

---

## The Jentic AIR Framework

Six dimensions, each scored 0–100%:

| Dimension | Abbreviation | What it measures |
|-----------|-------------|-----------------|
| Foundational Compliance | FC | Valid, structurally sound OpenAPI |
| Developer Experience | DX | Descriptions, summaries, examples |
| Agent Readiness & Agent Experience | ARAX | Agent-usable language, error recovery, disambiguation |
| Agent Usability | AU | Navigation, tagging, scale |
| Security | SEC | Auth documented and consistently applied |
| AI Discoverability | AID | Metadata for agent and tool discovery |

**Quick reference:** see [ai-readiness-quick-reference.md](./ai-readiness-quick-reference.md)

---

## Setup

### CLI Installation

```bash
# Global install (recommended)
npm install -g @jentic/api-scorecard-cli@latest
jentic-api-scorecard --version

# Or zero-install
npx @jentic/api-scorecard-cli@latest --version
```

**Docker must be running.** The scoring engine runs inside a Docker container. Start Docker Desktop before this session.

### API Key

Scoring local files requires a free Jentic API key (100 scorings/month):

1. Go to https://jentic.com/scorecard?tab=api-keys
2. Sign up / sign in and create a key
3. Export it: `export JENTIC_API_KEY=your-key-here`

**No key?** Use the browser scorer at https://jentic.com/scorecard — drag and drop any OpenAPI file.

### Verify Setup

```bash
jentic-api-scorecard score \
  https://raw.githubusercontent.com/jentic/jentic-public-apis/refs/heads/main/apis/openapi/swagger-api/petstore/1.0.27/openapi.json
```

You should see a scorecard for the Petstore (expected: ~68/100, B+). If it runs without error, you're ready.

---

## Choose Your Track

There are four tracks. Pick the one that best fits your time and interests.
Tracks A and C cover the same spec (Book Catalog) — A via CLI, C via agent skill.
Tracks B and D cover real-world APIs and improvement.

---

### Track A — Score Our API via CLI (~20 min)

Score the Book Catalog API using the `jentic-api-scorecard` CLI directly.
Understand where it stands and what each dimension measures.

**Go to:** [track-a/README.md](./track-a/README.md)

**Best for:** Understanding raw CLI output, getting comfortable with the `--detail`
flag progression, seeing how a well-designed spec scores.

---

### Track B — Score Real-World APIs via CLI (~25 min)

Score five production APIs (Spotify, Slack, Shopify, Box, Petstore) and compare
their AI-readiness profiles. Find out why a widely-used production API can score
C- while a well-designed one scores A-.

**Go to:** [track-b/README.md](./track-b/README.md)

**Best for:** Benchmarking, building intuition for what separates good specs from
great specs, discovering what "ARAX = F" looks like in practice.

---

### Track C — Score Using the Agent Skill (~20 min)

Use the `jentic-api-scorecard` Claude Code skill to score the same Book Catalog API,
then compare: how does conversational scoring via an agent differ from reading raw
CLI output?

**Go to:** [track-c/README.md](./track-c/README.md)

**Best for:** Exploring the agent-as-interface model, understanding when to use the
skill vs. the CLI, seeing how the agent interprets and explains scoring results.

---

### Track D — Improve with Agent Skills (~30 min)

Use the `jentic-api-improve` Claude Code skill to iteratively score and improve an
OpenAPI spec, targeting specific Jentic AIR Framework dimensions.

**Go to:** [track-d/README.md](./track-d/README.md)

**Best for:** Hands-on improvement work, seeing the improve skill in action,
understanding the ROI of targeted changes.

---

## Scoring Detail Levels

All tracks use the same CLI — just vary the `--detail` flag:

```bash
# Grade only
jentic-api-scorecard score --detail summary my-api.yaml

# Per-dimension breakdown (default)
jentic-api-scorecard score --detail dimensions my-api.yaml

# Per-signal breakdown within each dimension
jentic-api-scorecard score --detail signals my-api.yaml

# Full diagnostics — what's failing and why
jentic-api-scorecard score --detail diagnostics my-api.yaml
```

Start with `dimensions` to find the weakest area, then use `diagnostics` to pinpoint specific fixes.

---

## What to Expect

The Petstore — one of the most-referenced OpenAPI specs in the world — scores **B+ (68.6)**. It passes schema validation, but ARAX scores only 55% (C) and SEC scores 43% (D-).

That's the key insight of this module: **a technically valid spec is not an agent-ready spec.**

The gap between "compiles" and "an agent can use this reliably" is what the Jentic AIR Framework measures.
