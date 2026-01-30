#!/bin/bash
# setup-stitch-gcp.sh - GCP Authentication for Google Stitch MCP
# This is a wrapper that calls the Node.js OAuth script
#
# Usage: ./setup-stitch-gcp.sh [--check-only]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required but not installed."
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Run the Node.js OAuth script
node "$SCRIPT_DIR/setup-stitch-oauth.mjs" "$@"
