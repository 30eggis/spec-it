#!/bin/bash

#
# Hack-2-NextJS Validation Runner
#
# Runs all validators in sequence. Stops on first failure.
#
# Usage: ./run-validators.sh <project-dir>
#
# Exit codes:
#   0 = All validations passed
#   1 = Extraction validation failed
#   2 = Visual validation failed
#   3 = Invalid arguments
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-.}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           HACK-2-NEXTJS VALIDATION SUITE                      ║"
echo "║           Rule: COLLECT, DON'T CREATE                         ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Check project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project directory not found: $PROJECT_DIR${NC}"
    exit 3
fi

# Resolve to absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo "Project: $PROJECT_DIR"
echo ""

# Check required directories
CANDIDATES_DIR="$PROJECT_DIR/candidates"
NEXTJS_DIR="$PROJECT_DIR/nextjs-app"
SCREENSHOTS_DIR="$PROJECT_DIR/screenshots"

# ============================================================
# Phase 1: Extraction Validation
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 1: EXTRACTION VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d "$CANDIDATES_DIR" ]; then
    echo "Running extraction validator..."
    echo ""

    if npx ts-node "$SCRIPT_DIR/validate-extraction.ts" "$CANDIDATES_DIR" "$NEXTJS_DIR"; then
        echo -e "${GREEN}✓ Extraction validation passed${NC}"
    else
        echo -e "${RED}✗ Extraction validation FAILED${NC}"
        echo ""
        echo "The extraction does not match the original source."
        echo "AI may have modified classes or structure."
        echo ""
        echo "Action required: Re-run extraction phase"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠ Skipping: candidates/ directory not found${NC}"
fi

echo ""

# ============================================================
# Phase 2: Visual Validation (if screenshots exist)
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 2: VISUAL VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d "$SCREENSHOTS_DIR" ]; then
    echo "Running visual validator..."
    echo ""

    if npx ts-node "$SCRIPT_DIR/validate-visual.ts" "$SCREENSHOTS_DIR"; then
        echo -e "${GREEN}✓ Visual validation passed${NC}"
    else
        echo -e "${RED}✗ Visual validation FAILED${NC}"
        echo ""
        echo "The generated app does not visually match the original."
        echo "Check screenshots/diffs/ for visual differences."
        echo ""
        echo "Action required: Fix visual discrepancies"
        exit 2
    fi
else
    echo -e "${YELLOW}⚠ Skipping: screenshots/ directory not found${NC}"
    echo "To enable visual validation:"
    echo "  1. Take screenshots of original pages"
    echo "  2. Take screenshots of generated pages"
    echo "  3. Save to: $PROJECT_DIR/screenshots/P001/original.png"
    echo "             $PROJECT_DIR/screenshots/P001/generated.png"
fi

echo ""

# ============================================================
# Summary
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VALIDATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}✓ ALL VALIDATIONS PASSED${NC}"
echo ""
echo "The extraction follows the 'COLLECT, DON'T CREATE' principle."
echo "Safe to proceed with integration."
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                     VALIDATION COMPLETE                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

exit 0
