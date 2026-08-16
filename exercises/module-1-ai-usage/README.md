# Module 1: Understanding AI-Driven API Usage

**Duration:** ~25 minutes  
**Owner:** Erik Wilde  

## Objective

Before designing or improving APIs, you need to understand how AI agents actually interact with them — and where things go wrong. This exercise is analytical: no coding, no tools, just careful reading.

You will examine a real (but deliberately rough) API specification and map out the risks an AI agent would face when trying to use it autonomously.

---

## Setup

Open `book-catalog-raw.openapi.yaml`. This is a first-draft version of the Book Catalog API — the kind of spec that often gets auto-generated or written quickly without governance.

Read through it once before starting the worksheet. Notice:
- What the API claims to do
- How it's structured
- What information is present vs. missing

---

## Exercise: "Map the Risk"

Complete the worksheet in `risk-mapping-worksheet.md`.

The worksheet guides you through four lenses:

1. **Ambiguity** — Where is the API unclear in ways that could cause an agent to misinterpret intent?
2. **Unintended Workflows** — What could an agent do with this API that was never intended?
3. **Missing Information** — What is absent that would be critical for safe automated use?
4. **Governance Gaps** — What design decisions make this API harder to govern at scale?

Work individually for 15 minutes, then compare findings with the person next to you for 5 minutes.

---

## Debrief

After the group discussion, we'll share findings. Key themes to watch for:
- Credentials in query parameters
- Bare arrays with no schema (agent can't interpret the shape)
- Inconsistent naming (agent builds a mental model, then it breaks)
- Missing error responses (agent has no recovery path)
- RPC-style mutation endpoints (`/remove`, `/update_status`) — agent may confuse with GET
- Verb-based paths mixed with resource-based paths

---

## Connection to Module 2

The issues you identify here are exactly what the system prompt and design guidelines in Module 2 are built to prevent. When you design the Book Catalog API in the next module, you'll be solving the problems you just mapped.
