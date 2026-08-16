# jentic-workflows — Alternative Path

Use this guide if you prefer to generate the Arazzo workflow using the
`jentic-workflows` Claude Code skill instead of the Arazzo GPT.

---

## Prerequisites

The `jentic-workflows` skill must be installed in Claude Code. Verify with:

```
/jentic-workflows help
```

If the skill is not installed, see **Section 6** of `setup/prerequisites.md` for install instructions.

---

## Step 1 — Describe the Workflow Goal

Open Claude Code in this directory and run the skill with a natural-language
description of what you want:

```
/jentic-workflows

I want to model a book purchase workflow across two APIs.

APIs available (OpenAPI specs in the current directory):
- Book Catalog API: book-catalog-governed.openapi.yaml (base URL: https://api.example.com)
- Book Orders API: book-orders.openapi.yaml (base URL: https://orders.example.com)

Workflow goal: A user wants to buy a specific book they've identified.
The workflow should:
1. Verify the book exists (GET /books/{bookId} on Catalog API)
2. Find in-stock retailers (GET /books/{bookId}/retailers on Catalog API)
3. Place an order (POST /orders on Orders API) — requires Bearer auth
4. Process payment (POST /orders/{orderId}/payment on Orders API) — requires Bearer auth
5. Confirm the order (GET /orders/{orderId} on Orders API) — requires Bearer auth

Workflow inputs: bookId (UUID), paymentMethod (card|wallet), bearerToken (JWT string)
Workflow outputs: orderId, orderStatus, totalPaid (from subtotal.amount)

Key constraints:
- Step 4 returns HTTP 200 even on payment failure — success requires response body status == "succeeded"
- If payment fails, the workflow should terminate with a failure action
- If no in-stock retailers found in step 2, terminate the workflow
- Steps 3, 4, 5 need Authorization: Bearer {bearerToken} header

Output file: book-purchase.arazzo.yaml
```

---

## Step 2 — Review the Generated Spec

The skill will produce `book-purchase.arazzo.yaml`. Review:

1. **sourceDescriptions** — do both APIs have entries with correct `url` and `type: openapi`?
2. **inputs** — are `bookId`, `paymentMethod`, and `bearerToken` all present and typed?
3. **Data flow** — does each step reference outputs from the correct prior step?
   - Step 2 path param: `$steps.getBookDetails.outputs.bookId`
   - Step 3 request body: `$steps.getBookDetails.outputs.bookId`
   - Steps 4 & 5 path param: `$steps.createOrder.outputs.orderId`
4. **Success criteria** — does step 4 check `$response.body#/status == 'succeeded'`?
5. **Failure actions** — do steps 2 and 4 have `onFailure` → `type: end`?
6. **Auth headers** — do steps 3, 4, 5 pass `Authorization: Bearer {$inputs.bearerToken}`?

---

## Step 3 — Validate

```bash
spectral lint book-purchase.arazzo.yaml --ruleset .spectral.yaml
```

Fix any errors before proceeding. Warnings are expected — address them where
possible (add descriptions to steps and the workflow).

---

## Step 4 — Compare with Reference Solution

The reference solution is at `../../solutions/module-4/book-platform.arazzo.yaml`.

Key things to compare:
- Runtime expression paths in `outputs` fields
- The `successCriteria` on step `processPayment`
- The `onFailure` action structure
- How the `Authorization` header value is expressed

---

## Tips

- If the skill generates the wrong operationId, check that the OpenAPI specs
  in this directory have the correct `operationId` values on each operation.
- Runtime expressions in Arazzo follow JSON Pointer notation after the `#`:
  `$response.body#/id` → the `id` field at the root of the response body.
- For nested fields: `$response.body#/subtotal/amount` → `response.body.subtotal.amount`
