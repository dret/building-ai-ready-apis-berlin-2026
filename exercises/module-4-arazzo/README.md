# Module 4 — Arazzo Workflow Specification

**Duration:** ~30 minutes  
**Builds on:** Module 3 (the governed Book Catalog API spec)  
**Jump in?** See [JUMP-IN.md](./JUMP-IN.md)

---

## Overview

OpenAPI describes individual operations. Arazzo describes how those operations
are weaved together into a workflow.

In this module you'll author an Arazzo 1.0.1 specification that models a
five-step book purchase workflow spanning two APIs:

- **Book Catalog API** ([`book-catalog-governed.openapi.yaml`](./book-catalog-governed.openapi.yaml)) — verify book, find retailers
- **Book Orders API** ([`book-orders.openapi.yaml`](./book-orders.openapi.yaml)) — place order, process payment, confirm

The full workflow requirements are in [workflow-requirements.md](./workflow-requirements.md).

---

## Files in This Directory

| File | Purpose |
|------|---------|
| [`book-catalog-governed.openapi.yaml`](./book-catalog-governed.openapi.yaml) | Book Catalog API (governed output from Module 3) |
| [`book-orders.openapi.yaml`](./book-orders.openapi.yaml) | Book Orders API |
| [`workflow-requirements.md`](./workflow-requirements.md) | Detailed step-by-step requirements |
| [`.spectral.yaml`](./.spectral.yaml) | Spectral ruleset for validating Arazzo specs |
| [`arazzo-gpt-prompt.md`](./arazzo-gpt-prompt.md) | **Path A:** Ready-to-paste prompt for Arazzo GPT |
| [`jentic-workflows-prompt.md`](./jentic-workflows-prompt.md) | **Path B:** Instructions for the `jentic-workflows` skill |

---

## Learning Objectives

By the end of this module you will be able to:

1. Understand Arazzo's core concepts: `sourceDescriptions`, `workflows`, `steps`, `successCriteria`, `outputs`
2. Model cross-API data flow using runtime expressions (`$steps.<id>.outputs.<field>`)
3. Write success criteria that inspect response body fields, not just HTTP status codes
4. Declare failure actions that terminate a workflow on business-logic failures
5. Pass authentication headers through multi-step workflows

---

## Part 1 — Understand the APIs (5 min)

Before writing Arazzo, understand what you're working with.

Browse the two OpenAPI specs and answer these questions:

1. What is the `operationId` for "get a single book"? What path parameter does it need?
2. What is the `operationId` for "list retailers for a book"? How is the book identified?
3. `POST /orders` returns status code **201**. What field in the response body holds the new order's ID?
4. `POST /orders/{orderId}/payment` can return `status: succeeded` **or** `status: failed` — both with HTTP **200**. Why does this matter for your success criteria?
5. What schema does `GET /orders/{orderId}` return? What field path gives you the total paid amount?

---

## Part 2 — Generate the Arazzo Spec (25 min)

Choose **one** of these paths:

### Path A — Arazzo Specification GPT

Use the [Arazzo Specification Custom GPT](https://chatgpt.com/g/g-cM6GmgDXr-arazzo-specification)
with the ready-made prompt in [`arazzo-gpt-prompt.md`](./arazzo-gpt-prompt.md).

> **Before the session:** Verify you can access the GPT link above — it requires a ChatGPT
> account. If the link has moved, search ChatGPT for "Arazzo Specification".

1. Paste the prompt into the GPT
2. Paste (or link to) the two OpenAPI spec files when prompted
3. Review and copy the generated YAML
4. Save as `book-purchase.arazzo.yaml` in this directory

### Path B — jentic-workflows Claude Code Skill

Use the [`jentic-workflows` skill](https://github.com/jentic/jentic-skills) directly in Claude Code.
Follow the instructions in [`jentic-workflows-prompt.md`](./jentic-workflows-prompt.md).

### Path C — Build It Manually

Use Jentic's [Arazzo Editor](https://jentic.com/arazzo-editor) to manually construct the workflow. 
You can copy the Arazzo 1.0.1 structure below as your guide.

> Alternatively, you can use VSCode to manually create and use a visualizer from the marketplace to render your workflow.

**Minimal Arazzo structure:**

```yaml
arazzo: 1.0.1
info:
  title: Book Platform Workflows
  version: 1.0.0
  description: ...

sourceDescriptions:
  - name: bookCatalog
    url: ./book-catalog-governed.openapi.yaml
    type: openapi
  - name: bookOrders
    url: ./book-orders.openapi.yaml
    type: openapi

workflows:
  - workflowId: purchaseBook
    summary: Purchase a specific book
    description: ...
    inputs:
      type: object
      properties:
        bookId:
          type: string
          format: uuid
        paymentMethod:
          type: string
          enum: [card, wallet]
        bearerToken:
          type: string
      required: [bookId, paymentMethod, bearerToken]
    outputs:
      orderId: $steps.confirmOrder.outputs.orderId
      orderStatus: $steps.confirmOrder.outputs.orderStatus
      totalPaid: $steps.confirmOrder.outputs.totalPaid
    steps:
      - stepId: getBookDetails
        operationId: getBook
        parameters:
          - name: bookId
            in: path
            value: $inputs.bookId
        successCriteria:
          - condition: $statusCode == 200
        outputs:
          bookId: $response.body#/id
      # ... more steps
```

---

## Part 3 — Validate with Spectral (10 min)

Run Spectral against your generated file:

```bash
spectral lint book-purchase.arazzo.yaml --ruleset .spectral.yaml
```

Common issues to look for:

| Issue | Fix |
|-------|-----|
| `operationId` not found | Check the exact `operationId` in the OpenAPI spec files |
| Missing `description` on workflow/steps | Add a `description` field |
| Invalid runtime expression | Check JSON Pointer syntax: `$response.body#/field/subfield` |
| Missing `outputs` on workflow | Add an `outputs` map at the workflow level |

---

## Part 4 — Visualise in Arazzo UI (5 min)

Load your spec into the [Arazzo UI](https://arazzo-ui.jentic.com/) to see the workflow rendered as a diagram:

1. Go to [arazzo-ui.jentic.com](https://arazzo-ui.jentic.com/)
2. Paste your `book-purchase.arazzo.yaml`
3. Confirm all five steps appear in the correct order
4. Check that the data-flow edges between steps are visible (inputs → step → outputs)

This is a useful sanity check before the review discussion — if a step is missing or disconnected, it usually points to a runtime expression typo or a missing `outputs` declaration.

**Want to share or document the workflow?** Load the spec into [jentic.com/arazzo-editor](https://jentic.com/arazzo-editor) and use the export options to download the rendered workflow as Markdown or HTML.

---

## Part 5 — Review and Discuss (5 min)

1. **Data flow check** — trace the `bookId` from `$inputs.bookId` through
   `$steps.getBookDetails.outputs.bookId` into the `createOrder` request body.
   Does every step reference the correct source?

2. **Success criteria** — does your `processPayment` step check
   `$response.body#/status == 'succeeded'`? If you only check `$statusCode == 200`,
   your workflow will proceed even after a declined payment.

3. **Failure actions** — what happens if step 2 finds no retailers? What happens
   if payment is declined? Are there `onFailure` actions that terminate the workflow?

4. **Auth headers** — how do you express `Authorization: Bearer <token>` in Arazzo?
   Check how `$inputs.bearerToken` is used in the header value.

---

## Key Arazzo Concepts

### Runtime Expressions

Arazzo expressions reference values from earlier in the workflow:

| Expression | Meaning |
|-----------|---------|
| `$inputs.bookId` | Workflow input named `bookId` |
| `$steps.getBookDetails.outputs.bookId` | Output `bookId` from step `getBookDetails` |
| `$response.body#/id` | Field `id` at the root of the current step's response body |
| `$response.body#/subtotal/amount` | Nested field: `response.body.subtotal.amount` |
| `$statusCode` | HTTP status code of the current step's response |

### Success Criteria

```yaml
successCriteria:
  - condition: $statusCode == 200           # HTTP status check
  - condition: $response.body#/status == 'succeeded'  # body field check
```

Both conditions must be true for the step to succeed.

### Failure Actions

```yaml
onFailure:
  - name: paymentDeclined
    type: end    # terminate the workflow
```

`type: end` terminates the workflow immediately. You can also use `type: goto`
to jump to another step, or `type: retry` to retry the current step.

### Passing Auth Headers

```yaml
parameters:
  - name: Authorization
    in: header
    value: "Bearer {$inputs.bearerToken}"
```

The `{$expression}` syntax interpolates the expression value into a string.

---

## Validation Reference

```bash
# Validate your Arazzo file
spectral lint book-purchase.arazzo.yaml --ruleset .spectral.yaml

# Compare with reference solution
diff book-purchase.arazzo.yaml ../../solutions/module-4/book-platform.arazzo.yaml
```

The reference solution is at [`../../solutions/module-4/book-platform.arazzo.yaml`](../../solutions/module-4/book-platform.arazzo.yaml).
