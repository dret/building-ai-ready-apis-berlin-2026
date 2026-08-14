# Governance Policies — Book Catalog API

This document describes the governance policies you will enforce using OpenAPI Overlay in the exercise. Each policy is a real-world governance requirement that an API platform team might apply across multiple APIs without modifying the original source specs.

---

## Policy 1: Audience Targeting — Remove Internal Endpoints

**Why:** The Book Catalog API contains endpoints marked as internal (admin-only). These must not be exposed in the public-facing spec. Using Overlay allows the platform team to maintain a single source spec and produce audience-specific views without duplicating files.

**What to remove:**
The `book-catalog-with-internal.openapi.yaml` file contains two admin endpoints:
- `POST /books` — adds a new book (admin only)
- `PUT /books/{bookId}` — updates book metadata (admin only)

These endpoints are tagged with `x-internal: true`. Your Overlay must remove them from the public spec.

**Overlay task:** Use a `remove: true` action targeting these two path items.

---

## Policy 2: Contact and License Standardisation

**Why:** APIs published to external consumers must carry consistent, platform-governed contact and license information. Individual teams often omit or incorrectly fill these fields. Overlay lets the platform team enforce standard values without team-by-team coordination.

**What to update:**
Replace the existing `info.contact` object with the following standardised values:

```
name: API Platform Team
url: https://developer.example.com/support
email: api-support@example.com
```

Add or replace the `info.license` object with:

```
name: Apache 2.0
url: https://www.apache.org/licenses/LICENSE-2.0
```

**Overlay task:** Use two `update` actions — one targeting `$.info.contact`, one targeting `$.info.license`.

---

## Policy 3: Security Enforcement on Write Operations

**Why:** The reading list endpoints require authentication, but the source spec only defines the security scheme — it does not consistently apply it to all write operations. The platform governance policy requires that every `POST`, `PUT`, and `DELETE` operation in this API carries an explicit security requirement.

**What to add:**
Add `security: [{ bearerAuth: [] }]` to any write operation that does not already have it:
- `POST /reading-lists/me/entries`
- `PUT /reading-lists/me/entries/{bookId}`
- `DELETE /reading-lists/me/entries/{bookId}`

**Overlay task:** Use `update` actions targeting each write operation's `security` field.

---

## Bonus Policy: MCP Tool Metadata

**Why:** When an API is exposed as an MCP server, each operation becomes a callable tool. `x-mcp-tool-name` gives the tool a stable, machine-friendly name (snake_case, no spaces), and `x-agent-hint` gives agents a one-line behavioural contract: whether it is safe, whether it is destructive, what to call first, and what to watch for.

These two extensions are lightweight enough to apply via Overlay without touching the source spec, making them ideal for a governance pipeline.

**What to add:**
Apply the following MCP metadata to the reading list operations:

| Operation | `x-mcp-tool-name` | `x-agent-hint` |
|-----------|------------------|----------------|
| `GET /reading-lists/me` | `get_my_reading_list` | Safe, read-only. Returns the authenticated user's list only. Use this to check for a book before calling add_to_reading_list. |
| `POST /reading-lists/me/entries` | `add_to_reading_list` | Write operation. Returns 409 if the book is already on the list. Call get_my_reading_list first to avoid unnecessary errors. |
| `PUT /reading-lists/me/entries/{bookId}` | `update_reading_list_entry` | Write, idempotent. Updates status only. The book must already be on the list — 404 if not. |
| `DELETE /reading-lists/me/entries/{bookId}` | `remove_from_reading_list` | Destructive and irreversible. Permanently removes the entry. Require explicit user confirmation before calling. |

**Overlay task:** Use `update` actions targeting each operation, adding both `x-mcp-tool-name` and `x-agent-hint` fields.

Example action structure:

```yaml
- target: "$.paths['/reading-lists/me']['get']"
  update:
    x-mcp-tool-name: get_my_reading_list
    x-agent-hint: "Safe, read-only. Returns the authenticated user's list only. Use this to check for a book before calling add_to_reading_list."
```

---

## Tools

**Browser (no install) — Speakeasy Overlay Playground**
Visit: https://overlay.speakeasy.com
Paste your source spec and Overlay file to see the result in real time.

**CLI — @speclynx/cli**
```bash
npm install -g @speclynx/cli

speclynx overlay apply my-overlay.yaml book-catalog-with-internal.openapi.yaml \
  --output book-catalog-governed.openapi.yaml
```

---

## Validation

After applying your Overlay, validate the result:
```bash
spectral lint book-catalog-governed.openapi.yaml \
  --ruleset ../module-2-openapi-design/.spectral.yaml
```

The governed output should pass all Spectral rules and should no longer contain the admin endpoints.
