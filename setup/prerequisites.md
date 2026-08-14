# Workshop Prerequisites

**Do this before arriving.** The tools below require downloads and first-run
initialization that should not be done on conference WiFi.

**Estimated setup time:** 15–20 minutes

---

## 1. Node.js 20 LTS or newer

Required for: Spectral CLI, Jentic Scorecard CLI

```bash
node --version   # must be >= 20.19.0
npm --version    # must be >= 10.x
```

Download from https://nodejs.org/ if needed.

---

## 2. Docker Desktop

Required for: Jentic Scorecard CLI (scoring engine runs in a container)

```bash
docker info   # must return engine info, not an error
```

Download from https://docs.docker.com/get-docker/.  
**Start Docker Desktop before the session** — the daemon must be running.

---

## 3. Spectral CLI

Required for: Modules 2, 4 (linting OpenAPI and Arazzo specs)

```bash
npm install -g @stoplight/spectral-cli@latest
spectral --version
```

Verify it works:
```bash
spectral lint --help
```

---

## 4. @speclynx/cli

Required for: Module 3 (applying OpenAPI Overlay files from the CLI)

```bash
npm install -g @speclynx/cli
speclynx --version
```

Verify it works:
```bash
speclynx --help
```

---

## 5. Jentic API Scorecard CLI

Required for: Module 5 (AI-readiness scoring)

```bash
npm install -g @jentic/api-scorecard-cli@latest
jentic-api-scorecard --version
```

**Pre-pull the Docker scoring image** (takes 1–2 minutes, do this at home):

```bash
jentic-api-scorecard score \
  https://raw.githubusercontent.com/jentic/jentic-public-apis/refs/heads/main/apis/openapi/swagger-api/petstore/1.0.27/openapi.json
```

You should see a scorecard for the Petstore (B+, ~68). If it runs, you're ready.

**Jentic API key** (required for scoring local files):

1. Go to https://jentic.com/scorecard?tab=api-keys
2. Sign up / sign in (free account)
3. Create a key and export it:

```bash
export JENTIC_API_KEY=your-key-here
```

Add this to your shell profile (`.bashrc`, `.zshrc`) so it persists between sessions.

---

## 6. Claude Code

Required for: All modules (agent skill integration, spec generation, improvement)

Install via npm:
```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

Or install the VS Code extension from the VS Code marketplace: search "Claude Code".

**Authenticate** with your Anthropic account:
```bash
claude
```

This opens a browser for authentication. Complete it before the session.

**Install workshop agent skills:**

> These commands must be run **inside an active Claude Code session** — at the `>` prompt
> after running `claude` in your terminal. They are not shell commands.

```
/plugin marketplace add jentic/jentic-api-scorecard
/plugin install api-scorecard@jentic-api-scorecard
/plugin install api-improve@jentic-api-scorecard
```

**Optional — jentic-workflows skill (Module 4 Path B):**

The `jentic-workflows` skill is distributed from the `jentic/jentic-skills` GitHub repository.
Inside a Claude Code session, run:

```
Install the jentic-workflows skill from https://github.com/jentic/jentic-skills/tree/main/skills/jentic-workflows into your workspace skills directory.
```

Claude Code will fetch and install the skill. Verify it works with `/jentic-workflows help`.

---

## 7. Git

Required for: Cloning this repository

```bash
git --version   # any recent version is fine
```

Clone the workshop repository:

```bash
git clone https://github.com/frankkilcommins/building-ai-ready-apis-india-2026.git
cd building-ai-ready-apis-india-2026
```

---

## 8. Arazzo GPT Access (Module 4 option)

If you plan to use the Arazzo GPT for Module 4:

- You need a **ChatGPT account** (free tier works)
- The GPT is at: https://chatgpt.com/g/g-cM6GmgDXr-arazzo-specification
- **Verify you can access this link before arriving** — if it returns a 404, search ChatGPT
  for "Arazzo Specification" or use Path B (jentic-workflows) or Path C (manual) instead

---

## 9. Text Editor / IDE

Any editor works. VS Code is recommended if you want inline OpenAPI validation:

- Install the **Redocly OpenAPI** extension for inline linting
- Install the **YAML** extension for schema validation

---

## Fallback Options

If you can't install the CLI tools, web-based alternatives work for most exercises:

| Tool | Web alternative |
|------|----------------|
| Spectral CLI | https://editor.swagger.io (built-in OAS validation) or https://redocly.com/tools/redoc/playground |
| Jentic Scorecard CLI | https://jentic.com/scorecard (drag-and-drop) |
| Claude Code | claude.ai in the browser |
| Swagger Editor | https://editor.swagger.io |

---

## Verify Everything Works

Run this check before arriving:

```bash
node --version         # >= 20.19.0
docker info            # engine running
spectral --version     # installed
jentic-api-scorecard --version  # installed
claude --version       # installed and authenticated
```

If any of these fail, see the troubleshooting notes or open an issue at
https://github.com/frankkilcommins/building-ai-ready-apis-india-2026/issues.
