# Track C — Score Using the Agent Skill

**Time:** ~20 minutes  
**Goal:** Use the `jentic-api-scorecard` Claude Code skill to score the Book Catalog API
and explore how an AI agent interprets, explains, and reasons about scoring results —
compared to reading raw CLI output yourself.

---

## Prerequisites

The `jentic-api-scorecard` skill must be installed in Claude Code:

```
/plugin marketplace add jentic/jentic-api-scorecard
/plugin install api-scorecard@jentic-api-scorecard
```

A Jentic API key is required:

```bash
export JENTIC_API_KEY=your-key-here
```

---

## Setup

The `book-catalog-governed.openapi.yaml` file is already in this directory. No setup required.

---

## Part 1 — Score via the Agent Skill (10 min)

Open Claude Code in this directory. Instead of running the CLI yourself, ask Claude:

```
Score book-catalog-governed.openapi.yaml for AI-readiness.
Show me the dimension scores and tell me which dimension has the most room for improvement.
```

Watch what the skill does:
- Does it run the CLI under the hood, or use a different mechanism?
- How does it present the results — raw numbers, or interpreted findings?
- Does it make suggestions without being asked?

Then ask follow-up questions:

```
Why did [WEAKEST_DIMENSION] score low?
What are the two highest-impact changes I could make to improve it?
```

```
Which signals in the ARAX dimension are failing?
What would I need to change to push ARAX from [SCORE] to 70%?
```

Note: there are no "wrong" answers here. The goal is to explore how conversational
scoring differs from scripted CLI usage.

---

## Part 2 — Compare with Raw CLI Output (5 min)

Now run the same scorecard directly from the terminal:

```bash
jentic-api-scorecard score --detail diagnostics book-catalog-governed.openapi.yaml
```

Compare the two outputs:

| Aspect | Agent skill | Raw CLI |
|--------|-------------|---------|
| Dimension scores | | |
| Explanation of failures | | |
| Suggested fixes | | |
| Format / readability | | |
| Follow-up interactivity | | |

---

## Part 3 — Reflection (5 min)

1. **What did the agent tell you that the CLI didn't?**  
   Was the interpretation useful, or did it add noise?

2. **What did the raw CLI tell you that the agent missed?**  
   Any details in the diagnostics output that the agent glossed over?

3. **When would you use the agent skill vs. the CLI directly?**  
   Think: exploration vs. CI/CD, interactive triage vs. batch scoring.

4. **What does this tell you about agent skills as an interface pattern?**  
   Is "ask, don't script" always better? When does it break down?

---

## Key Insight

The agent skill and the CLI run the same scoring engine. The difference is in the
**interface**:

- The CLI is deterministic, scriptable, composable with `jq`, usable in CI.
- The agent skill is conversational, interpretive, and can reason across multiple scorecards.

Neither is better in all cases. The skill shines for exploration and triage;
the CLI shines for automation and enforcement.

---

## If You Have Time — Score a Second Spec

Try scoring one of the real-world samples using the agent skill:

```
Score ../track-b/slack.json for AI-readiness.
The ARAX dimension is expected to be very low — explain why and what's causing it.
```

Then compare the agent's explanation with the raw CLI output from Track B.
