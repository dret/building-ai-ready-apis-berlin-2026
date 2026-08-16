# Book Platform — API User Story

## Context

You are designing the **Book Catalog API** for a digital book platform. The platform serves both human consumers (web and mobile apps) and AI agents that autonomously discover, browse, and trigger purchasing workflows.

The same API must be safe and predictable for both audiences. Automated consumers must not be able to trigger unintended side effects or misinterpret ambiguous responses.

---

## Story

**As a developer building a book discovery application**, I need an API that allows me to:

1. **Search and browse books** — retrieve a paginated list of books with the ability to filter by genre, author, minimum rating, and maximum price, so I can surface relevant titles to users without loading the entire catalog.

2. **Get book details** — fetch full information about a specific book including its title, author, description, genre, publication date, page count, average rating, and price, so I can show a rich detail view.

3. **Find where to buy** — for a given book, retrieve a list of retailers (both physical stores and online retailers) with availability status and their price for that book, so I can help users find the best place to purchase.

4. **Browse books by author** — retrieve an author's profile and all books they have written, so I can power author pages.

5. **Manage a reading list** — allow authenticated users to add books to their personal reading list with a status (want-to-read, reading, finished), retrieve their list, and remove entries.

---

## Rules

- The catalog is read-only for public consumers — nobody can add or modify books through this API
- Book search must support filtering by genre, authorId, minRating (1–5), maxPrice, and a text search query
- The reading list endpoints require authentication (Bearer JWT)
- Prices must be represented as decimal strings with a currency code — never as floating point numbers
- All collection endpoints must be paginated with offset/limit and return a data/meta wrapper
- Genres are a fixed enum: `fiction`, `non-fiction`, `science`, `history`, `biography`, `technology`, `children`
- Retailer availability is one of: `in-stock`, `out-of-stock`, `pre-order`
- Reading list status is one of: `want-to-read`, `reading`, `finished`
- Error responses must follow RFC 9457 Problem Details format
- The API should include rate-limiting headers on all responses

---

## Domain Model

### Book
- `id` — UUID, system-generated
- `title` — string, required
- `description` — string, required
- `genre` — enum (see above), required
- `publishedAt` — date (ISO 8601), required
- `pageCount` — integer, required
- `averageRating` — number 1–5, system-calculated
- `price` — `{ amount: string, currency: string }`, required
- `coverImageUrl` — URL, optional
- `authorId` — UUID, references Author, required
- `createdAt`, `updatedAt` — date-time, system-generated

### Author
- `id` — UUID, system-generated
- `name` — string, required
- `biography` — string, optional
- `photoUrl` — URL, optional
- `websiteUrl` — URL, optional
- `createdAt`, `updatedAt` — date-time, system-generated

### Retailer (per-book)
- `id` — UUID
- `name` — string (e.g., "Amazon", "Waterstones")
- `type` — enum: `online`, `physical`
- `availability` — enum (see above)
- `price` — `{ amount: string, currency: string }`
- `url` — URL (online only, optional)
- `address` — string (physical only, optional)

### ReadingListEntry
- `bookId` — UUID, references Book
- `status` — enum (see above)
- `addedAt` — date-time, system-generated
- `updatedAt` — date-time, system-generated

---

## Expected Endpoints (Guidance — not prescriptive)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/books` | Search and browse books |
| GET | `/books/{bookId}` | Get full book details |
| GET | `/books/{bookId}/retailers` | List retailers for a book |
| GET | `/authors` | List/search authors |
| GET | `/authors/{authorId}` | Get author profile |
| GET | `/authors/{authorId}/books` | Get books by an author |
| GET | `/reading-lists/me` | Get my reading list (auth) |
| POST | `/reading-lists/me/entries` | Add book to reading list (auth) |
| PUT | `/reading-lists/me/entries/{bookId}` | Update reading list entry status (auth) |
| DELETE | `/reading-lists/me/entries/{bookId}` | Remove from reading list (auth) |

---

## Exercise Options

**Option A — LLM-assisted generation:**
Paste the system prompt from `system-prompts/openapi-design-assistant.md` into your LLM of choice, then send this user story as the prompt. Use the output as your starting point.

**Option B — Complete the skeleton:**
Open `book-catalog-skeleton.openapi.yaml` and complete the `# TODO` sections. The structure is already set up — you are filling in descriptions, schemas, and examples.

**Option C — Agent skill:**
If you are using Claude Code, you can ask the assistant to design the API using this story as input. The `jentic-api-scorecard` skill will be available to pre-score your output.

After generating or completing the spec, proceed to **Part B: Validate** and **Part C: Lint**.
