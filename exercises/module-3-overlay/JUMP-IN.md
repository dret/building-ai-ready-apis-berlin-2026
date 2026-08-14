# Module 3 — Jump-In Guide

**Arriving mid-workshop? Start here.**

## What This Module Is About

You'll apply governance policies to an existing OpenAPI spec using Overlay — without editing the source file. This is the pattern for enforcing API standards at scale across many APIs.

## Files You Need

| File | Purpose |
|------|---------|
| `book-catalog-with-internal.openapi.yaml` | Source spec with admin endpoints (the one you govern) |
| `audience-targeting.overlay.yaml` | Pre-provided working overlay you can apply immediately |
| `governance-policies.md` | The policies you need to enforce |
| `README.md` | Step-by-step instructions for each task |

## Quickest Path (5 minutes)

A working overlay is already provided. Apply it to see Overlay in action before writing your own:

**Browser (no install):**
1. Go to https://overlay.speakeasy.com
2. Paste `book-catalog-with-internal.openapi.yaml` as the source spec
3. Paste `audience-targeting.overlay.yaml` as the overlay
4. The `POST /books` and `PUT /books/{bookId}` admin endpoints will be gone from the output

**CLI:**
```bash
speclynx overlay apply audience-targeting.overlay.yaml book-catalog-with-internal.openapi.yaml \
  --output book-catalog-governed.openapi.yaml
```

Then follow `README.md` Tasks 1–3 to write the remaining overlays yourself.

## Reference Solutions

`../../solutions/module-3/` contains completed Overlay files and the final governed spec.
