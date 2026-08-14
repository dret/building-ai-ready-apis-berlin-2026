# Track B — Score Real-World APIs

**Time:** ~25 minutes  
**Goal:** Score five well-known production APIs, compare their AI-readiness profiles, and understand what separates a 51 from a 75.

---

## Setup

```bash
jentic-api-scorecard --version
export JENTIC_API_KEY=your-key-here
```

Get a free key at https://jentic.com/scorecard?tab=api-keys, or use the browser scorer at **https://jentic.com/scorecard**.

---

## The Sample Files

| File | API | Ops | Expected Score |
|------|-----|-----|----------------|
| `petstore.json` | Swagger Petstore v3 | 19 | 🟡 B+ (~68) |
| `spotify.json` | Spotify Web API | 89 | 🟢 A- (~75) |
| `box.json` | Box Platform API | 296 | 🟡 B+ (~68) |
| `shopify.json` | Shopify REST Admin | 273 | 🟠 C+ (~58) |
| `slack.json` | Slack Web API | 169 | 🟠 C- (~51) |

---

## Part 1 — Score All Five (10 min)

```bash
jentic-api-scorecard score --detail dimensions petstore.json
jentic-api-scorecard score --detail dimensions spotify.json
jentic-api-scorecard score --detail dimensions box.json
jentic-api-scorecard score --detail dimensions shopify.json
jentic-api-scorecard score --detail dimensions slack.json
```

Record the dimension scores in the comparison table below.

---

## Comparison Table

Fill this in as you run the scorecards:

| Dimension | Petstore | Spotify | Box | Shopify | Slack |
|-----------|----------|---------|-----|---------|-------|
| **FC** (Foundational) | | | | | |
| **DX** (Dev Experience) | | | | | |
| **ARAX** (Agent Readiness) | | | | | |
| **AU** (Agent Usability) | | | | | |
| **SEC** (Security) | | | | | |
| **AID** (Discoverability) | | | | | |
| **Overall** | | | | | |

---

## Part 2 — Deep Dive on Slack (10 min)

Slack scores the lowest in the set (~51) despite being a production API used by millions of developers. Investigate why:

```bash
jentic-api-scorecard score --detail diagnostics slack.json
```

1. **ARAX fails badly** — What specific signal is causing it? (Hint: look at `summary_coverage`)

2. **How many operations lack summaries?** Look at the diagnostic output — is there a count?

3. **What would it take to fix?** How many lines of YAML would you need to add to push ARAX from F to C?

---

## Part 3 — Best-in-Class Analysis (5 min)

Spotify scores the highest in the set (~75). Look at what it does well:

```bash
jentic-api-scorecard score --detail signals spotify.json
```

1. **Where does Spotify score highest?** Which dimension is its strongest?

2. **Where does Spotify still fall short?** Even the best spec in this set has weaknesses — what are they?

3. **What's the single biggest gap between Slack and Spotify?** If Slack fixed just one thing, which fix would have the largest score impact?

---

## Optional Extension — Score Any API

Score any API you're interested in. The Jentic Public API Library (OAK) contains thousands of scored APIs — browse it to find raw GitHub URLs:

```bash
# OpenAI API — 242 ops
jentic-api-scorecard score \
  https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml

# GitHub REST API — 1,186 ops (takes ~40s)
jentic-api-scorecard score \
  https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json
```

Or score your own company's API if you have it handy:

```bash
jentic-api-scorecard score --detail signals path/to/your-api.yaml
```
