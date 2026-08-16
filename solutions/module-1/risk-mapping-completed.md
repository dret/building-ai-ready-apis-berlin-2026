# Risk Mapping — Completed Reference
## Book Catalog API — AI Interaction Analysis

**Reference answers for facilitators and participants who finish early.**

---

## 1. Ambiguity Analysis

### 1.1 Operations with no descriptions

Every operation in `book-catalog-raw.openapi.yaml` has no description. The full list:

- `GET /api/v1/books/list` — is this a search? A browse? Are results ordered?
- `GET /api/v1/books/{id}` — what does `id` look like? UUID? Integer?
- `GET /api/v1/books/{id}/buy-locations` — what is a "buy location"? Online only? In-store?
- `GET /api/v1/author/{author_id}/books` — returns what shape? Any filtering?
- `POST /api/v1/user/readinglist` — creates an entry? Replaces the list? Both?
- `POST /api/v1/user/readinglist/remove` — deletes what exactly? One entry or the list?
- `POST /api/v1/user/readinglist/update_status` — updates which status, on what?

**What an agent would fail to infer:**
- Whether `list` filtering is possible vs. always returning all books
- That `readinglist/remove` destroys data (no description, no `DELETE` method signal)
- The difference between `update_status` and a full PUT — are other fields preserved?
- Whether `author_id` in the path is the same type as `AuthorId` in the book response

---

### 1.2 The `genre` query parameter

The spec defines `genre` as `type: string` with no `enum` constraint and no description.

An agent has **no way to know** which values are valid. It would have to guess from context
(e.g., "fiction", "non-fiction") or try values and handle errors. The API likely returns
400 or 200 (empty) on invalid genre — but since there are no error responses defined,
the agent can't distinguish "bad request" from "no results".

**Fix:** Define `genre` as an enum with documented values, or add a description listing valid choices.

---

### 1.3 The `price` field

The `price` field is `type: number`. This is ambiguous in three ways:

1. **Type:** floating-point numbers cannot represent prices precisely (e.g., 19.99 becomes 19.989999...)
2. **Currency:** there is no `currency` field — is this USD? INR? The caller cannot know
3. **Units:** is 2000 → ₹2,000 or $20.00?

**Impact for agents:** An agent told to "find the cheapest book" would sort by this number, but two
books priced in different currencies would be compared incorrectly.

**Fix:** Use `type: string` with a decimal pattern + a `currency` field (ISO 4217), or use a Money object.

---

### 1.4 The `stock_status` field

The `stock_status` field is `type: string` with no enum and no description. An agent cannot know:

- What values are valid: is it "in_stock", "in-stock", "InStock", "available"?
- How to interpret a value like "limited" — is that in-stock or not?
- Whether a null or missing field means out-of-stock

**Impact:** An agent filtering for in-stock retailers would have to guess the exact string value.
If it guesses wrong, it might recommend out-of-stock retailers or skip all of them.

---

### 1.5 Naming conventions

Patterns in the spec:
- Snake_case: `book_id`, `author_id`, `avg_rating`, `stock_status`, `buy_url`, `user_token`
- PascalCase: `BookTitle`, `AuthorId`, `Price`, `Status`
- Lowercase: `author`, `title` (varies inconsistently)

**Problems for agents:**
- An agent building a workflow must know exactly which case to use when referencing fields.
  If step 1 returns `book_id` and step 2 expects `bookId`, the chain silently breaks.
- Code generation from this spec would produce inconsistent variable names.
- Agents doing schema-matching across operations cannot reliably correlate `author` with `AuthorId`.

---

## 2. Unintended Workflow Analysis

### 2.1 Credentials in query parameters

`?user_token=ABC123` in the URL:

- **Logged everywhere:** web servers, proxies, CDNs, and browser history all log full URLs.
  The token appears in server access logs, CDN logs, and analytics.
- **Shareable risk:** a user copy-pasting a URL to share it inadvertently shares their token.
- **Agent risk:** an agent building a URL might include the token in a log message, a summary,
  or pass it to another API as a string.
- **Caching:** CDNs and HTTP caches may cache the URL with the token embedded.

**Fix:** Credentials must go in the `Authorization` header, never query parameters.

---

### 2.2 Unintentional deletion via `POST /readinglist/remove`

**How an agent might trigger this:**
- An agent sees a list of `POST` endpoints and might call "remove" when asked to
  "clean up duplicates", "reorganize the reading list", or "remove the book I finished"
- With no description or warning, the agent has no signal that this is a destructive operation
- Using `POST` (normally safe) instead of `DELETE` removes the HTTP method as a safety signal

**What's missing:**
- An HTTP `DELETE` method (which agents treat as destructive by convention)
- A description warning about irreversibility
- Confirmation pattern or soft-delete option
- 404 vs 200 disambiguation on "book not in list"

---

### 2.3 Finding the cheapest buy location

**What the agent must assume:**
- That `price` values across all buy-locations are in the same currency (unverified)
- That `stock_status` values are interpretable (no enum — must guess valid values)
- That the lowest numeric `price` actually means cheapest in absolute terms

**What could go wrong:**
- Agent picks a retailer with `stock_status: "pre-order"` because it's cheapest — user can't buy it today
- Agent compares ₹1000 with $15 as numbers — picks $15 as "cheaper" when it's actually more expensive
- Agent gets an empty array but has no description to know whether the book is simply unavailable

---

### 2.4 The `Status` field in `POST /readinglist`

No enum, no description. Valid values are completely unknown. An agent sending an
unexpected value (e.g., `"read"` instead of `"finished"`) gets either a 400 (if the server
validates) or silent acceptance with undefined behaviour (if it doesn't).

Neither case is safe: a 400 with no error schema is unhandleable; silent acceptance with
wrong data corrupts user state.

---

## 3. Missing Information

### 3.1 Operations with no error responses

Every operation in this spec lacks error response definitions:

- `GET /api/v1/books/list` — what's returned for invalid `genre`? 400? 200 empty?
- `GET /api/v1/books/{id}` — what happens if the book doesn't exist? 404? 200 null?
- `GET /api/v1/books/{id}/buy-locations` — 404 if book not found, or 200 empty array?
- `GET /api/v1/author/{author_id}/books` — what if the author doesn't exist?
- `POST /api/v1/user/readinglist` — what on duplicate book? 409? 200?
- `POST /api/v1/user/readinglist/remove` — what if the book isn't in the list?
- `POST /api/v1/user/readinglist/update_status` — what if status is invalid?

**What an agent must do on failure:** treat any non-2xx as a fatal error and stop the workflow.
It cannot distinguish "book not found" from "server error" from "auth failure" — all look the same.

---

### 3.2 No security scheme defined

There is no `securitySchemes` in `components` and no `security` field on any operation.

A developer (or agent) must reverse-engineer authentication from the query parameter names
(`user_token`). There is no way to know:
- Which operations require authentication (all? only writing?)
- What type of token is expected (JWT? API key? session cookie?)
- How to obtain a token (no `tokenUrl`, no OAuth flows, no description)

An agent building a workflow would call unauthenticated first, fail with a 401 (if lucky),
and have no schema to parse the error response.

---

### 3.3 No pagination metadata

`GET /api/v1/books/list` returns a bare array. An agent has no way to know:
- Whether there are more pages (no `totalCount`, no `nextPage`, no `hasMore`)
- How many results the server will return per call (no `limit`/`offset` params defined)
- Whether the array is complete or a truncated page

**In practice:** the agent fetches once, processes what it gets, and may miss 90% of the catalog.
Or it may enter an infinite loop trying to find a "next page" that doesn't exist.

---

### 3.4 Empty object schema on author books

`GET /api/v1/author/{author_id}/books` returns `type: array, items: type: object` with no properties.

When an agent receives this response, it:
- Cannot extract any field by name (e.g., it doesn't know the book has a `title`)
- Cannot correlate this response to the Book schema (no `$ref`)
- Will either fail trying to access `title` (undefined) or require trial-and-error
- Has no way to know if the response is the same schema as `GET /api/v1/books/{id}` or different

---

## 4. Governance Gaps

### 4.1 Version in path + verb in path

`/api/v1/books/list` — two problems:
- `v1` in the path means **every URL** must change on a major version bump. All existing integrations,
  bookmarks, agent memories, and documentation links break simultaneously.
- `/list` is a verb, not a resource — it conflates what the operation does with where the resource is.
  REST and RESTful best practices use nouns: `/books` is the collection.

For agents: if `/api/v2/` is introduced, the agent's cached knowledge of `/api/v1/books/list` is
immediately stale. There's no forwarding, no discoverability of the new path.

---

### 4.2 Mixed casing on the same concept

`book_id` (snake_case in paths and some responses) and `BookTitle`/`AuthorId` (PascalCase in other responses).

**In a chained workflow:**
- Step 1 returns `{"book_id": "123", "BookTitle": "Dune"}`
- Step 2 expects `bookId` in the request body
- The agent must transform `book_id` → `bookId` — but has no schema mapping to know this

This transformation is invisible in the spec. The workflow silently fails with a 400 or
processes data with the wrong field name.

---

### 4.3 POST for status update

`POST /api/v1/user/readinglist/update_status` should be `PUT /reading-lists/me/entries/{bookId}`.

Why it matters for agents:
- `POST` is not idempotent — agents may retry a POST after a timeout, creating duplicate entries
  or sending multiple status updates
- `PUT` signals "replace this resource" — agents know to check for a 404 before updating
- HTTP method conventions are how agents infer safety: `GET` = safe, `PUT` = idempotent,
  `DELETE` = destructive. Using `POST` for everything defeats these safety signals

---

### 4.4 Multiple authentication mechanisms

The spec implies at least two authentication approaches:
1. `?user_token=...` query parameter — used in readinglist endpoints
2. No auth at all — implied for catalog endpoints (but not stated)

**Governance failure:**
- Inconsistency means every agent/developer must test each endpoint to discover its auth requirement
- If a future endpoint adds header-based auth, there are now three mechanisms
- Security audits cannot reliably find all authenticated endpoints by searching for a pattern
- Token rotation (changing user_token) must be coordinated across all query-param usages simultaneously

---

## 5. Summary

### Top 3 risks

1. **Credentials in query parameters (`user_token`)** — tokens are logged and leaked via URLs.
   This is a security vulnerability that could expose user accounts to anyone with access to logs.

2. **Destructive operations with no safety signals** — `POST /readinglist/remove` looks like any
   other POST operation. An agent cannot tell it deletes data. There are no HTTP method signals,
   no description warnings, no confirmation patterns.

3. **Ambiguous `price` field with no currency** — an agent comparing prices across retailers in
   different currencies could recommend the wrong retailer. Financial decisions based on this spec
   are unreliable.

### Where "find and add to reading list" would fail

Most likely failure points in order:

1. **Authentication** — no security scheme means the agent guesses where to put the token.
   It probably tries the header first, gets a 401 with no error schema, and fails.

2. **Finding a book** — `?genre=fiction` is a guess. The valid enum is unknown. If the server
   rejects it, there's no error schema to help recovery.

3. **Chaining `book_id` → readinglist POST** — the agent extracts `book_id` from the search
   response but `POST /readinglist` may expect `bookId` or `BookId` — inconsistent casing breaks the chain.

4. **Confirming success** — the POST to readinglist returns a bare 200 with an object that has
   no schema. The agent can't confirm the entry was created vs. a silent failure.

### Single highest-impact change

**Add a security scheme and apply it consistently.**

This single change would:
- Make auth requirements explicit on every operation
- Tell agents which operations require tokens before they fail
- Enable code generators to produce correct auth headers automatically
- Signal to governance tools which operations expose user data

All other issues (naming, descriptions, error responses) are also critical, but without
a security scheme, the API cannot be used safely at all by any automated consumer.
