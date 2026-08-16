#!/usr/bin/env bash
# Workshop prerequisite checker and quick installer
# Run this before arriving: bash setup/quick-install.sh

set -euo pipefail

PASS="✓"
FAIL="✗"
WARN="~"

check() {
  local label="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "$PASS  $label"
    return 0
  else
    echo "$FAIL  $label"
    return 1
  fi
}

echo ""
echo "========================================="
echo "  Building AI-Ready APIs Workshop"
echo "  Prerequisite Checker"
echo "========================================="
echo ""

ERRORS=0

# Node.js
if node --version 2>/dev/null | grep -qE '^v(2[0-9]|[3-9][0-9])'; then
  echo "$PASS  Node.js $(node --version) (>= 20 required)"
else
  echo "$FAIL  Node.js >= 20.19.0 required — download from https://nodejs.org/"
  ERRORS=$((ERRORS + 1))
fi

# Docker
if docker info &>/dev/null; then
  echo "$PASS  Docker is running"
else
  echo "$FAIL  Docker is not running — start Docker Desktop"
  ERRORS=$((ERRORS + 1))
fi

# Spectral CLI
if spectral --version &>/dev/null; then
  echo "$PASS  Spectral CLI $(spectral --version)"
else
  echo "$WARN  Spectral CLI not found — installing..."
  npm install -g @stoplight/spectral-cli@latest && echo "$PASS  Spectral CLI installed"
fi

# speclynx CLI (Overlay application)
if speclynx --version &>/dev/null; then
  echo "$PASS  speclynx $(speclynx --version)"
else
  echo "$WARN  speclynx not found — installing..."
  npm install -g @speclynx/cli && echo "$PASS  speclynx installed"
fi

# Jentic Scorecard CLI
if jentic-api-scorecard --version &>/dev/null; then
  echo "$PASS  jentic-api-scorecard $(jentic-api-scorecard --version)"
else
  echo "$WARN  jentic-api-scorecard not found — installing..."
  npm install -g @jentic/api-scorecard-cli@latest && echo "$PASS  jentic-api-scorecard installed"
fi

# Claude Code
if claude --version &>/dev/null; then
  echo "$PASS  Claude Code $(claude --version)"
else
  echo "$WARN  Claude Code not found — install with: npm install -g @anthropic-ai/claude-code"
  ERRORS=$((ERRORS + 1))
fi

# Jentic API Key
if [[ -n "${JENTIC_API_KEY:-}" ]]; then
  echo "$PASS  JENTIC_API_KEY is set"
else
  echo "$WARN  JENTIC_API_KEY not set — needed for Module 5 (local file scoring)"
  echo "       Get a free key at https://jentic.com/scorecard?tab=api-keys"
  echo "       Then: export JENTIC_API_KEY=your-key-here"
fi

echo ""
echo "========================================="

if [[ $ERRORS -eq 0 ]]; then
  echo "  All required tools are ready!"
  echo ""
  echo "  Run this final smoke test to confirm the scoring engine works:"
  echo ""
  echo "  jentic-api-scorecard score \\"
  echo "    https://raw.githubusercontent.com/jentic/jentic-public-apis/refs/heads/main/apis/openapi/swagger-api/petstore/1.0.27/openapi.json"
else
  echo "  $ERRORS required tool(s) missing — see setup/prerequisites.md"
fi

echo "========================================="
echo ""
