#!/usr/bin/env bash
# Check script for nix-darwin configuration
# Runs various validation and quality checks

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Nix-Darwin Configuration Check${NC}"
echo ""

# Track if any checks fail
CHECKS_PASSED=true

# Function to run a check
run_check() {
    local name=$1
    local command=$2
    
    echo -e "${YELLOW}Running: ${name}${NC}"
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ ${name} passed${NC}"
    else
        echo -e "${RED}  ✗ ${name} failed${NC}"
        CHECKS_PASSED=false
    fi
}

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found. Please run from the nix-darwin directory.${NC}"
    exit 1
fi

echo -e "${BLUE}📝 Running checks...${NC}"
echo ""

# Format check
run_check "Format check" "nix fmt -- --check ."

# Flake check
run_check "Flake validation" "nix flake check --no-build"

# Dead code check
if command -v deadnix &> /dev/null; then
    run_check "Dead code check" "deadnix --fail ."
else
    echo -e "${YELLOW}  ⚠ deadnix not found, skipping dead code check${NC}"
fi

# Anti-pattern check
if command -v statix &> /dev/null; then
    run_check "Anti-pattern check" "statix check ."
else
    echo -e "${YELLOW}  ⚠ statix not found, skipping anti-pattern check${NC}"
fi

# Evaluation check
run_check "Configuration evaluation" "nix eval .#darwinConfigurations.aimdevlee.config.system.build.toplevel --raw"

# Build dry-run
echo ""
echo -e "${YELLOW}Running: Build dry-run${NC}"
if darwin-rebuild build --flake . --dry-run > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Build dry-run passed${NC}"
else
    echo -e "${RED}  ✗ Build dry-run failed${NC}"
    CHECKS_PASSED=false
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ "$CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}✨ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please fix the issues above.${NC}"
    exit 1
fi