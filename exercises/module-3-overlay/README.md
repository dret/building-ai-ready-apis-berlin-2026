# Module 3: Applying Governance with OpenAPI Overlay

**Duration:** ~20 minutes  
**Owner:** Frank Kilcommins  

## Objective

Apply governance policies to the Book Catalog API using **OpenAPI Overlay** — without modifying the original specification file. This is the governance-at-scale pattern: a single source spec, multiple governed views.

---

## Background

The version of the Book Catalog API in this module (`book-catalog-with-internal.openapi.yaml`) is the complete source spec — it includes internal admin endpoints that must not be published externally, and it needs standardised contact/license information before it can be published to the developer portal.

Your job is to write Overlay files that transform this spec into a governed, publication-ready version.

---

## Quick Start — See an Overlay in Action First

A working overlay is pre-provided: **`audience-targeting.overlay.yaml`**

Apply it now to see the result before writing your own:

**Browser (no install):**
1. Go to [overlay.speakeasy.com](https://overlay.speakeasy.com)
2. Paste `book-catalog-with-internal.openapi.yaml` as the source spec
3. Paste the contents of `audience-targeting.overlay.yaml`
4. Observe: the `POST /books` and `PUT /books/{bookId}` admin endpoints are removed

**CLI:**
```bash
# Install (once)
npm install -g @speclynx/cli

# Run all CLI commands from this directory
cd exercises/module-3-overlay

# Apply the overlay
speclynx overlay apply audience-targeting.overlay.yaml book-catalog-with-internal.openapi.yaml \
  --output book-catalog-governed.openapi.yaml

# Confirm the admin endpoints are gone
grep -c "operationId: createBook" book-catalog-governed.openapi.yaml   # should return 0
grep -c "operationId: updateBook" book-catalog-governed.openapi.yaml   # should return 0
```

Once you've seen it working, continue to the tasks below.

---

## Exercise Structure

There are three tasks. Tasks 1–2 are required; Task 3 is a bonus.

Read `governance-policies.md` for the full policy requirements before starting.

### Task 1 — Standardise Contact and License (~10 min)

Create `contact-license.overlay.yaml` that replaces the `info.contact` object and `info.license` object with the platform-standard values defined in `governance-policies.md`.

Use the `update` action with the replacement object as the value:

```yaml
overlay: 1.0.0
info:
  title: Contact and License Governance
  version: 1.0.0
actions:
  - target: "$.info.contact"
    update:
      name: <platform standard name from governance-policies.md>
      url: <platform standard url>
      email: <platform standard email>
  - target: "$.info.license"
    update:
      name: <platform standard license>
      url: <platform standard license url>
```

### Task 2 — Enforce Security on Write Operations (~10 min)

Create `security-enforcement.overlay.yaml` that adds `security: [{ bearerAuth: [] }]` to the three write operations on the reading list — even if the source spec already declares them.

This is the **platform enforcement pattern**: the overlay acts as a governance guarantee that security is always present in the published spec, regardless of whether the source spec was authored correctly. This is how platform teams enforce standards at scale without trusting every team's source spec.

The three targets are:
- `POST /reading-lists/me/entries`
- `PUT /reading-lists/me/entries/{bookId}`
- `DELETE /reading-lists/me/entries/{bookId}`

**Hint:** Overlay JSONPath for a specific operation:
```
$.paths['/reading-lists/me/entries']['post']
```

### Task 3 (Bonus) — MCP Tool Metadata (~10 min)

Create `ai-annotations.overlay.yaml` that adds `x-mcp-tool-name` and `x-agent-hint` to the four reading list operations as described in `governance-policies.md`.

`x-mcp-tool-name` gives each operation a stable snake_case tool name for MCP clients. `x-agent-hint` provides a one-line behavioural contract — safe vs. destructive, preconditions, what to call first.

See the example action structure in `governance-policies.md` before starting.

---

## Applying Overlays

### Browser (no install) — Speakeasy Overlay Playground
1. Go to [overlay.speakeasy.com](https://overlay.speakeasy.com)
2. Paste `book-catalog-with-internal.openapi.yaml` as the source spec
3. Paste your Overlay YAML
4. The resulting spec is shown in the right panel

### CLI — @speclynx/cli

Install once:
```bash
npm install -g @speclynx/cli
```

Apply a single overlay:
```bash
speclynx overlay apply contact-license.overlay.yaml book-catalog-with-internal.openapi.yaml \
  --output book-catalog-governed.openapi.yaml
```

Apply all overlays in sequence using the `--overlay` flag (start from the pre-provided audience-targeting one):
```bash
speclynx overlay apply audience-targeting.overlay.yaml book-catalog-with-internal.openapi.yaml \
  --overlay contact-license.overlay.yaml \
  --overlay security-enforcement.overlay.yaml \
  --output book-catalog-governed.openapi.yaml
```

---

## Validation

After applying your Overlays, confirm the result is correct:

```bash
# Should pass with no errors
spectral lint book-catalog-governed.openapi.yaml \
  --ruleset ../module-2-openapi-design/.spectral.yaml

# The admin endpoints should be gone
grep -c "operationId: createBook" book-catalog-governed.openapi.yaml   # should return 0
```

---

## Reference Solutions

```
../../solutions/module-3/audience-targeting.overlay.yaml
../../solutions/module-3/contact-license.overlay.yaml
../../solutions/module-3/security-enforcement.overlay.yaml
../../solutions/module-3/ai-annotations.overlay.yaml
../../solutions/module-3/book-catalog-governed.openapi.yaml
```

---

## Other Files in This Directory

| File | Purpose |
|------|---------|
| `book-catalog-with-internal.openapi.yaml` | **Source spec** — the one you apply overlays to |
| `audience-targeting.overlay.yaml` | Pre-provided working overlay (Quick Start example) |
| `governance-policies.md` | Governance policy requirements for Tasks 1–3 |
| `book-catalog-reference.openapi.yaml` | Reference copy of the Module 2 solution (without internal endpoints) — for comparison only, not used in the exercise |
| `JUMP-IN.md` | 2-minute context for late arrivals |

---

## What You've Built

The `book-catalog-governed.openapi.yaml` produced by applying all overlays is the starting point for **Module 4**, where you'll model a multi-step workflow spanning the Book Catalog API and a new Book Orders API.
