# Jump-In Guide

Every module in this workshop is self-contained. If you arrive late, need to restart,
or want to skip ahead, use this guide to find the exact files you need.

---

## How to Jump In

1. Find the module in the table below
2. Copy the **starter file(s)** to your working directory
3. Read the module's `JUMP-IN.md` (2-3 min) for context
4. Open the module's `README.md` for full exercise instructions

---

## Module Starter Files

### Module 1 — Understanding AI-Driven API Usage

**No prior context needed** — the worksheet and spec are fully self-contained.

| What you need | Where to find it |
|---------------|----------------|
| Raw spec to analyse | [`exercises/module-1-ai-usage/book-catalog-raw.openapi.yaml`](exercises/module-1-ai-usage/book-catalog-raw.openapi.yaml) |
| Risk mapping worksheet | [`exercises/module-1-ai-usage/risk-mapping-worksheet.md`](exercises/module-1-ai-usage/risk-mapping-worksheet.md) |
| Jump-in brief | [`exercises/module-1-ai-usage/JUMP-IN.md`](exercises/module-1-ai-usage/JUMP-IN.md) |
| Reference answers | [`solutions/module-1/risk-mapping-completed.md`](solutions/module-1/risk-mapping-completed.md) |

---

### Module 2 — Designing with OpenAPI

**Starter file:** The skeleton spec gives you a pre-structured starting point.

| What you need | Where to find it |
|---------------|----------------|
| Skeleton spec (jump-in starter) | [`exercises/module-2-openapi-design/book-catalog-skeleton.openapi.yaml`](exercises/module-2-openapi-design/book-catalog-skeleton.openapi.yaml) |
| User story | [`exercises/module-2-openapi-design/user-story.md`](exercises/module-2-openapi-design/user-story.md) |
| System prompt | [`exercises/module-2-openapi-design/system-prompts/openapi-design-assistant.md`](exercises/module-2-openapi-design/system-prompts/openapi-design-assistant.md) |
| Spectral ruleset | [`exercises/module-2-openapi-design/.spectral.yaml`](exercises/module-2-openapi-design/.spectral.yaml) |
| Jump-in brief | [`exercises/module-2-openapi-design/JUMP-IN.md`](exercises/module-2-openapi-design/JUMP-IN.md) |
| Reference solution | [`solutions/module-2/book-catalog.openapi.yaml`](solutions/module-2/book-catalog.openapi.yaml) |

---

### Module 3 — Overlay Governance

**Starter file:** Use the Module 2 reference solution as your source spec.

| What you need | Where to find it |
|---------------|----------------|
| Source spec with internal endpoints | [`exercises/module-3-overlay/book-catalog-with-internal.openapi.yaml`](exercises/module-3-overlay/book-catalog-with-internal.openapi.yaml) |
| Governance policies | [`exercises/module-3-overlay/governance-policies.md`](exercises/module-3-overlay/governance-policies.md) |
| Jump-in brief | [`exercises/module-3-overlay/JUMP-IN.md`](exercises/module-3-overlay/JUMP-IN.md) |
| Reference overlays | [`solutions/module-3/audience-targeting.overlay.yaml`](solutions/module-3/audience-targeting.overlay.yaml) |
| | [`solutions/module-3/contact-license.overlay.yaml`](solutions/module-3/contact-license.overlay.yaml) |
| | [`solutions/module-3/security-enforcement.overlay.yaml`](solutions/module-3/security-enforcement.overlay.yaml) |
| | [`solutions/module-3/ai-annotations.overlay.yaml`](solutions/module-3/ai-annotations.overlay.yaml) |
| Governed output | [`solutions/module-3/book-catalog-governed.openapi.yaml`](solutions/module-3/book-catalog-governed.openapi.yaml) |

---

### Module 4 — Arazzo Workflows

**Starter files:** Both OpenAPI specs are pre-provided. No Module 3 work needed.

| What you need | Where to find it |
|---------------|----------------|
| Book Catalog API (governed) | [`exercises/module-4-arazzo/book-catalog-governed.openapi.yaml`](exercises/module-4-arazzo/book-catalog-governed.openapi.yaml) |
| Book Orders API | [`exercises/module-4-arazzo/book-orders.openapi.yaml`](exercises/module-4-arazzo/book-orders.openapi.yaml) |
| Workflow requirements | [`exercises/module-4-arazzo/workflow-requirements.md`](exercises/module-4-arazzo/workflow-requirements.md) |
| Arazzo GPT prompt | [`exercises/module-4-arazzo/arazzo-gpt-prompt.md`](exercises/module-4-arazzo/arazzo-gpt-prompt.md) |
| jentic-workflows prompt | [`exercises/module-4-arazzo/jentic-workflows-prompt.md`](exercises/module-4-arazzo/jentic-workflows-prompt.md) |
| Spectral ruleset | [`exercises/module-4-arazzo/.spectral.yaml`](exercises/module-4-arazzo/.spectral.yaml) |
| Jump-in brief | [`exercises/module-4-arazzo/JUMP-IN.md`](exercises/module-4-arazzo/JUMP-IN.md) |
| Reference solution | [`solutions/module-4/book-platform.arazzo.yaml`](solutions/module-4/book-platform.arazzo.yaml) |

---

### Module 5 — AI-Ready Ecosystems

**Starter files:** Sample specs are pre-provided. Choose your track.

| What you need | Where to find it |
|---------------|----------------|
| Track A — Book Catalog (CLI scoring) | [`exercises/module-5-ai-readiness/track-a/book-catalog-governed.openapi.yaml`](exercises/module-5-ai-readiness/track-a/book-catalog-governed.openapi.yaml) |
| Track B — Real-world samples (CLI) | [`exercises/module-5-ai-readiness/track-b/`](exercises/module-5-ai-readiness/track-b/) (petstore, spotify, slack, shopify, box) |
| Track C — Agent skill scoring | [`exercises/module-5-ai-readiness/track-c/`](exercises/module-5-ai-readiness/track-c/) |
| Track D — Agent skill improvement | [`exercises/module-5-ai-readiness/track-d/README.md`](exercises/module-5-ai-readiness/track-d/README.md) |
| Jentic AIR Framework quick reference | [`exercises/module-5-ai-readiness/ai-readiness-quick-reference.md`](exercises/module-5-ai-readiness/ai-readiness-quick-reference.md) |
| Jump-in brief | [`exercises/module-5-ai-readiness/JUMP-IN.md`](exercises/module-5-ai-readiness/JUMP-IN.md) |
| Improved reference spec | [`solutions/module-5/book-catalog-improved.openapi.yaml`](solutions/module-5/book-catalog-improved.openapi.yaml) |

---

## Progressive File Flow

Each module's output becomes the next module's input:

```
book-catalog-raw.openapi.yaml          (Module 1 — analyse risks)
         ↓
book-catalog.openapi.yaml              (Module 2 — design/improve)
         ↓
book-catalog-governed.openapi.yaml     (Module 3 — apply overlays)
         ↓
book-platform.arazzo.yaml              (Module 4 — model workflow)
         ↓
book-catalog-improved.openapi.yaml     (Module 5 — score and improve)
```

At any point, you can use the reference solution from `solutions/module-N/`
as your jump-in starter for module N+1.

---

## Reference Solutions

| Module | Location |
|--------|----------|
| Module 1 | [`solutions/module-1/risk-mapping-completed.md`](solutions/module-1/risk-mapping-completed.md) |
| Module 2 | [`solutions/module-2/book-catalog.openapi.yaml`](solutions/module-2/book-catalog.openapi.yaml) |
| Module 3 | [`solutions/module-3/`](solutions/module-3/) (4 overlay files + governed spec) |
| Module 4 | [`solutions/module-4/book-platform.arazzo.yaml`](solutions/module-4/book-platform.arazzo.yaml) |
| Module 5 | [`solutions/module-5/book-catalog-improved.openapi.yaml`](solutions/module-5/book-catalog-improved.openapi.yaml) |
