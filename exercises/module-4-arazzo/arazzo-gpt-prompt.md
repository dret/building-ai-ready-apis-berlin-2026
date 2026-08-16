# Arazzo GPT — Suggested Prompt

Use this prompt with the [Arazzo Specification Custom GPT](https://chatgpt.com/g/g-cM6GmgDXr-arazzo-specification) to generate the Book Purchase workflow.

---

## Prompt

```
I need to model a multi-step book purchase workflow as an Arazzo 1.0.1 specification.

The workflow spans two APIs:

1. Book Catalog API — base URL: https://api.example.com
   OpenAPI spec: [paste or link to book-catalog-governed.openapi.yaml]

2. Book Orders API — base URL: https://orders.example.com
   OpenAPI spec: [paste or link to book-orders.openapi.yaml]

Workflow name: purchaseBook
Description: A deterministic workflow that verifies a book exists, finds an in-stock
retailer, places an order, processes payment, and confirms the order.

Workflow inputs:
- bookId (string, UUID) — the book to purchase
- paymentMethod (string, enum: card|wallet) — the payment method
- bearerToken (string) — JWT for API authentication

Steps:
1. getBookDetails — GET /books/{bookId} on Catalog API (input: bookId from workflow inputs)
2. findRetailers — GET /books/{bookId}/retailers on Catalog API (input: bookId from step 1 outputs; successCriteria: at least one in-stock retailer)
3. createOrder — POST /orders on Orders API (input: bookId from step 1, quantity 1; output: orderId from response body)
4. processPayment — POST /orders/{orderId}/payment on Orders API (input: orderId from step 3; paymentMethod from workflow inputs; successCriteria: response body status == "succeeded")
5. confirmOrder — GET /orders/{orderId} on Orders API (input: orderId from step 3; successCriteria: response body status == "confirmed")

Workflow outputs:
- orderId from step 5 response
- orderStatus from step 5 response
- totalPaid from step 5 response (subtotal.amount)

Steps 3, 4, 5 require Authorization: Bearer {$inputs.bearerToken} header.

Please generate a complete, valid Arazzo 1.0.1 YAML document.
```

---

## After Generating

1. Save the output as `book-purchase.arazzo.yaml`
2. Validate it: `spectral lint book-purchase.arazzo.yaml --ruleset .spectral.yaml`
3. Fix any issues reported by Spectral
4. Review the data flow references — check that `$steps.<stepId>.outputs.<field>` paths match actual response schema field names from the OpenAPI specs
