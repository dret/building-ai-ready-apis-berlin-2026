# Workflow Requirements — Book Purchase Workflow

## Overview

Design a multi-step workflow that takes a user from book discovery through to completed purchase. The workflow spans two APIs:

- **Book Catalog API** (`book-catalog-governed.openapi.yaml`) — search, browse, retail lookup
- **Book Orders API** (`book-orders.openapi.yaml`) — place order, process payment

## APIs

| API | Base URL | Spec File |
|-----|----------|-----------|
| Book Catalog API | `https://api.example.com` | `book-catalog-governed.openapi.yaml` |
| Book Orders API | `https://orders.example.com` | `book-orders.openapi.yaml` |

---

## Workflow: Purchase a Specific Book

**Goal:** A user wants to buy a specific book they've identified. The workflow should find the cheapest in-stock retailer, confirm the book details, place an order, process payment, and confirm the order.

### Steps

**Step 1 — Verify book exists and get its details**  
Call `GET /books/{bookId}` on the Catalog API.  
Input: `bookId` (provided externally as workflow input)  
Success: The book record is returned  
Output used downstream: `bookId`, `title`, `price`

**Step 2 — Find an in-stock retailer**  
Call `GET /books/{bookId}/retailers` on the Catalog API.  
Input: `bookId` from Step 1 output  
Success: A retailer list is returned with at least one `in-stock` entry  
Output used downstream: the first `in-stock` retailer's `price` (for reference)  
Failure action: If no in-stock retailers found, the workflow should fail with a clear message

**Step 3 — Place the order**  
Call `POST /orders` on the Orders API.  
Input: `bookId` from Step 1, quantity = 1  
Success: Order created with `status: pending`  
Output used downstream: `orderId`

**Step 4 — Process payment**  
Call `POST /orders/{orderId}/payment` on the Orders API.  
Input: `orderId` from Step 3, `paymentMethod` from workflow inputs  
Success: Payment result with `status: succeeded`  
Failure action: If payment fails, mark the workflow step as failed with the `failureReason`

**Step 5 — Confirm the order**  
Call `GET /orders/{orderId}` on the Orders API.  
Input: `orderId` from Step 3  
Success: Order with `status: confirmed`  
Output: `orderId`, `status`, `subtotal` as workflow outputs

---

## Workflow Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| `bookId` | string (UUID) | Yes | The book to purchase |
| `paymentMethod` | string (`card` or `wallet`) | Yes | Payment method to use |
| `bearerToken` | string | Yes | JWT for authenticating API calls |

## Workflow Outputs

| Output | Source | Description |
|--------|--------|-------------|
| `orderId` | Step 5 response | ID of the confirmed order |
| `orderStatus` | Step 5 response | Final order status (should be `confirmed`) |
| `totalPaid` | Step 5 response | Total amount charged |

---

## Key Design Considerations

1. **Data flow** — How does `bookId` from Step 1's output feed into Step 2's path parameter? In Arazzo, this is expressed as `$steps.getBookDetails.outputs.bookId`

2. **Success criteria** — Step 4 returns `200` even on payment failure. Your success criteria for Step 4 should check `$response.body#/status == 'succeeded'`, not just the HTTP status.

3. **Failure actions** — Step 4 should have a `failureAction` that terminates the workflow if payment fails, passing the `failureReason` to the output.

4. **Security** — The `bearerToken` input must be passed as an `Authorization` header to Steps 3, 4, and 5. In Arazzo, this is done via step-level `parameters`.
