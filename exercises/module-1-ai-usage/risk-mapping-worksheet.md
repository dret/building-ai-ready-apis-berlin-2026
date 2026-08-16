# Risk Mapping Worksheet
## Book Catalog API — AI Interaction Analysis

**API File:** `book-catalog-raw.openapi.yaml`  
**Time:** 15 minutes individual + 5 minutes pair discussion

---

## Instructions

For each section below, examine the spec and answer the questions. Be specific — reference path names, field names, or operation IDs where relevant.

---

## 1. Ambiguity Analysis

> Ambiguity forces an agent to guess. Every guess is a potential failure.

**1.1** List operations that have no description. What would an agent have to infer about these?

```
Operations with no description:
-
-
-

What would an agent infer? (Or fail to infer?)
-
-
```

**1.2** The `genre` query parameter accepts a `string`. What values are valid? How would an agent know?

```
Your answer:
```

**1.3** Look at the `price` field across different responses. What type is it? What are the units? What currency?

```
Your answer:
```

**1.4** The `stock_status` field in the buy-locations response is a string. What values could it have? How would an agent decide whether to recommend a retailer to a user?

```
Your answer:
```

**1.5** Compare `book_id`, `BookTitle`, `Author`, `avg_rating`, and `Price` in the response schemas. What naming conventions are in use?

```
Patterns you see:
-

Problems this creates for an agent:
-
```

---

## 2. Unintended Workflow Analysis

> If an agent can do it, it will eventually try it.

**2.1** The reading list endpoints accept authentication via a `user_token` query parameter. What risks does this create?

```
Your answer:
```

**2.2** The `POST /api/v1/user/readinglist/remove` endpoint removes a book from a reading list. How might an agent trigger this unintentionally? What's missing that would make it safer?

```
Your answer:
```

**2.3** An agent is told to "find the cheapest place to buy a book". Looking at `GET /api/v1/books/{id}/buy-locations`, what would it have to assume to execute this? What could go wrong?

```
What the agent must assume:
-
-

What could go wrong:
-
-
```

**2.4** Consider the `POST /api/v1/user/readinglist` endpoint. What status values could the `Status` field contain? Is there any constraint? What happens if an agent sends an unexpected value?

```
Your answer:
```

---

## 3. Missing Information

> What's not there is often more dangerous than what is.

**3.1** List every operation that has no error responses defined. For each, describe what an agent must do when it gets an unexpected HTTP status.

```
Operations with no error responses:
-
-
-
-

What must an agent do on failure?
```

**3.2** There is no security scheme defined in this spec. How would a developer (or an agent) know which endpoints require authentication?

```
Your answer:
```

**3.3** The `GET /api/v1/books/list` endpoint returns an array with no pagination metadata. How would an agent know if there are more pages? How would it decide how many pages to fetch?

```
Your answer:
```

**3.4** The `GET /api/v1/author/{author_id}/books` response is defined as `type: array, items: type: object` with no properties. What happens when an agent tries to use the results?

```
Your answer:
```

---

## 4. Governance Gaps

> A spec that's hard to govern is a spec that will be misused at scale.

**4.1** This API has `/api/v1/` in the path and uses the path `/api/v1/books/list` (with `list` as a segment). What problems does this create if the API needs to evolve?

```
Your answer:
```

**4.2** There are two naming conventions for the same concept in different parts of the spec: `book_id` (snake_case) and `bookId` (camelCase). If an agent is building a workflow that chains these operations, what breaks?

```
Your answer:
```

**4.3** The update status endpoint is `POST /api/v1/user/readinglist/update_status`. What HTTP method would be more appropriate? Why does it matter for agents?

```
Your answer:
```

**4.4** How many distinct authentication mechanisms are implied by this spec? List them and explain why inconsistency here is a governance failure.

```
Your answer:
```

---

## 5. Summary

After completing the sections above, fill in this summary.

**Top 3 risks you identified (most dangerous first):**

1. 
2. 
3. 

**If an AI agent tried to execute a complete "find and add to reading list" workflow using this API, where would it most likely fail?**

```
Your answer:
```

**What single change to this spec would have the greatest positive impact on AI safety?**

```
Your answer:
```

---

## Reference

After the group debrief, compare your findings with `../../solutions/module-1/risk-mapping-completed.md`.
