# Module 2 — Jump-In Guide

**Arriving mid-workshop? Start here.**

## What This Module Is About

You'll design an OpenAPI 3.1.2 specification for a Book Catalog API that is safe for both human developers and AI agents to consume. The exercise has three parts: Generate → Validate → Lint.

## Files You Need

| File | Purpose |
|------|---------|
| `user-story.md` | What the API should do (domain + requirements) |
| `system-prompts/openapi-design-assistant.md` | Paste into your LLM as system prompt |
| `book-catalog-skeleton.openapi.yaml` | Pre-structured skeleton if you prefer not to generate from scratch |
| `.spectral.yaml` | Linting ruleset — run after generating your spec |

## Quickest Path (10 minutes)

1. Skip Part A — use the skeleton: `book-catalog-skeleton.openapi.yaml`
2. Fill in at least 3 of the `# TODO` description fields
3. Run `spectral lint book-catalog-skeleton.openapi.yaml --ruleset .spectral.yaml`
4. See what errors and warnings appear — this gives you the feel for Part C

## Reference Solution

If you want to see a completed spec to orient yourself:  
`../../solutions/module-2/book-catalog.openapi.yaml`
