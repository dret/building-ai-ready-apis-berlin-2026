# Module 4 — Jump In

Haven't done Modules 1–3? No problem. Everything you need is in this directory.

---

## Context (2 min read)

You're working with two well-designed APIs:

- **Book Catalog API** (`book-catalog-governed.openapi.yaml`) — browse books,
  find retailers. Public read operations + authenticated reading list.
- **Book Orders API** (`book-orders.openapi.yaml`) — place orders, process payment.
  All operations require a Bearer JWT.

Your task: write an **Arazzo 1.0.1** specification that describes a five-step
book purchase workflow spanning both APIs.

**Arazzo** is a standard for describing multi-step API workflows — it captures
data flow between steps, success/failure criteria, and authentication. Think of
it as the "glue" that connects individual OpenAPI operations into a choreographed sequence.

---

## The Workflow (1 min read)

```
Step 1: GET /books/{bookId}              → verify book exists, get bookId
Step 2: GET /books/{bookId}/retailers    → confirm in-stock retailer exists
Step 3: POST /orders                     → place order, get orderId
Step 4: POST /orders/{orderId}/payment   → process payment (check body, not status!)
Step 5: GET /orders/{orderId}            → retrieve confirmed order
```

Inputs: `bookId`, `paymentMethod` (card|wallet), `bearerToken` (JWT)  
Outputs: `orderId`, `orderStatus`, `totalPaid`

---

## Quickest Path (15 min)

**Option A — Arazzo GPT:**
1. Open `arazzo-gpt-prompt.md`
2. Paste the prompt into the [Arazzo Specification GPT](https://chatgpt.com/g/g-cM6GmgDXr-arazzo-specification)
3. Attach or paste both OpenAPI spec files
4. Save the output as `book-purchase.arazzo.yaml`
5. Validate: `spectral lint book-purchase.arazzo.yaml --ruleset .spectral.yaml`

**Option B — jentic-workflows skill:**
1. Open `jentic-workflows-prompt.md`
2. Follow the instructions to run the `/jentic-workflows` skill
3. Validate as above

---

## Key Things to Check After Generation

1. Does step 4 (`processPayment`) check `$response.body#/status == 'succeeded'`?
   (HTTP 200 is returned for both success AND failure — you must check the body.)

2. Do steps 3, 4, 5 include an `Authorization` header set to
   `"Bearer {$inputs.bearerToken}"`?

3. Does step 3's request body reference
   `$steps.getBookDetails.outputs.bookId` — not `$inputs.bookId`?

4. Do steps 2 and 4 have `onFailure` actions that terminate the workflow?

---

## Reference Solution

`../../solutions/module-4/book-platform.arazzo.yaml`
