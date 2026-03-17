#!/usr/bin/env bash
# Setup script for Idea-Validation pipeline tools
# Run this on any new machine after cloning the repo:
#   bash scripts/setup.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TOOLS_DIR="$PROJECT_DIR/tools"

ENGRAM_VERSION="1.10.1"

echo "=== Idea-Validation Setup ==="
echo "Project: $PROJECT_DIR"
echo ""

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  mingw*|msys*|cygwin*) OS="windows" ;;
  linux) OS="linux" ;;
  darwin) OS="darwin" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

EXT="tar.gz"
[[ "$OS" == "windows" ]] && EXT="zip"

ENGRAM_FILE="engram_${ENGRAM_VERSION}_${OS}_${ARCH}.${EXT}"
ENGRAM_URL="https://github.com/Gentleman-Programming/engram/releases/download/v${ENGRAM_VERSION}/${ENGRAM_FILE}"

mkdir -p "$TOOLS_DIR"

# --- Engram ---
if [[ -f "$TOOLS_DIR/engram.exe" ]] || [[ -f "$TOOLS_DIR/engram" ]]; then
  echo "[OK] Engram already installed"
else
  echo "[1/2] Downloading Engram v${ENGRAM_VERSION} for ${OS}/${ARCH}..."
  curl -L -o "$TOOLS_DIR/$ENGRAM_FILE" "$ENGRAM_URL"

  echo "     Extracting..."
  if [[ "$EXT" == "zip" ]]; then
    unzip -o "$TOOLS_DIR/$ENGRAM_FILE" -d "$TOOLS_DIR"
  else
    tar -xzf "$TOOLS_DIR/$ENGRAM_FILE" -C "$TOOLS_DIR"
  fi

  rm -f "$TOOLS_DIR/$ENGRAM_FILE"
  echo "[OK] Engram installed"
fi

# Verify
if [[ "$OS" == "windows" ]]; then
  "$TOOLS_DIR/engram.exe" --version
else
  chmod +x "$TOOLS_DIR/engram"
  "$TOOLS_DIR/engram" --version
fi

# --- open-websearch ---
if ! command -v node &>/dev/null; then
  echo "[WARN] Node.js not found. open-websearch requires Node.js."
  echo "       Install Node.js and re-run this script."
else
  if [[ -d "$TOOLS_DIR/node_modules/open-websearch" ]]; then
    echo "[OK] open-websearch already installed"
  else
    echo "[2/2] Installing open-websearch..."
    cd "$TOOLS_DIR"
    npm init -y 2>/dev/null
    npm install open-websearch
    echo "[OK] open-websearch installed"
  fi
fi

echo ""
echo "=== Setup complete ==="
echo "Restart Claude Code to pick up the MCP servers."
