# Track D — Improve with Agent Skills

**Time:** ~30 minutes  
**Goal:** Use the `jentic-api-improve` Claude Code skill to iteratively improve an OpenAPI spec's AI-readiness score, targeting specific Jentic AIR Framework dimensions.

---

## Prerequisites

The `jentic-api-improve` skill must be installed in Claude Code:

```
/plugin marketplace add jentic/jentic-api-scorecard
/plugin install api-improve@jentic-api-scorecard
```

Also ensure the scorecard CLI is available:

```bash
jentic-api-scorecard --version
export JENTIC_API_KEY=your-key-here
```

---

## The Setup

Copy the Book Catalog spec into this track directory to work on it:

```bash
cp ../track-a/book-catalog-governed.openapi.yaml ./book-catalog-to-improve.openapi.yaml
```

Or use the spec you scored in Track C:

```bash
cp ../track-c/book-catalog-governed.openapi.yaml ./book-catalog-to-improve.openapi.yaml
```

Establish your baseline score first:

```bash
jentic-api-scorecard score --detail dimensions book-catalog-to-improve.openapi.yaml
```

Note the weakest dimension and its score. That's your improvement target.

---

## Part 1 — Targeted Improvement (20 min)

Open Claude Code in this directory and invoke the improvement skill:

```
/jentic-api-improve

I want to improve the AI-readiness of book-catalog-to-improve.openapi.yaml.

Please:
1. Run the scorecard and show me the current dimension scores
2. Identify the weakest dimension
3. Propose specific, targeted changes to improve that dimension by at least 10 percentage points
4. Apply the changes to book-catalog-to-improve.openapi.yaml
5. Re-score and show me the before/after comparison

Focus on one dimension at a time. Start with whichever has the lowest score.
```

Watch what the skill does:
- What signals does it identify as failing?
- What changes does it propose?
- Does the score actually improve after its changes?

---

## Part 2 — Second Pass (10 min)

After the first improvement run, pick the next weakest dimension and run the skill again targeting that specifically:

```
/jentic-api-improve

The [DIMENSION] score is still low at [SCORE]%. 
Please target this dimension specifically. 
Run diagnostics to find the specific failing signals, 
propose changes, apply them, and re-score.
```

---

## Reflection Questions

1. **What kinds of changes does the skill make?**  
   Does it add descriptions? Change structure? Add extensions?

2. **Which dimension was easiest to improve? Which was hardest?**

3. **Is there a point of diminishing returns?**  
   After two improvement passes, how much higher is the score than the baseline?

4. **What does this tell you about designing APIs from scratch vs. retrofitting?**

---

## Compare with Reference Solution

The reference improved spec is at `../../../solutions/module-5/book-catalog-improved.openapi.yaml`.

```bash
jentic-api-scorecard score --detail dimensions \
  ../../../solutions/module-5/book-catalog-improved.openapi.yaml
```

```bash
# See what changed between the governed and improved versions
diff ../track-a/book-catalog-governed.openapi.yaml \
  ../../../solutions/module-5/book-catalog-improved.openapi.yaml
```

---

## Optional — Improve Slack Instead

If you want a bigger challenge, try improving the Slack spec:

```bash
cp ../track-b/slack.json ./slack-to-improve.json
```

```
/jentic-api-improve

I want to improve the AI-readiness of slack-to-improve.json.
The ARAX dimension scores F because summary_coverage is 0.00 —
not one of the 169 operations has a summary field.
Please add summaries to all operations, re-score, and show me the improvement.
```

This is a more dramatic improvement scenario — going from C- to B on a real production API spec.
