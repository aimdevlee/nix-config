#!/usr/bin/env bash
# Update script for nix-darwin configuration
# Updates all flake inputs and rebuilds the system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 Nix-Darwin Update Script${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found. Please run from the nix-darwin directory.${NC}"
    exit 1
fi

# Update flake inputs
echo -e "${YELLOW}📦 Updating flake inputs...${NC}"
nix flake update

# Show what was updated
echo ""
echo -e "${YELLOW}📋 Updated inputs:${NC}"
git diff flake.lock | grep -E "^\+" | grep -E "lastModified|rev" | head -20

# Build the new configuration
echo ""
echo -e "${YELLOW}🔨 Building new configuration...${NC}"
darwin-rebuild build --flake .

# Ask for confirmation before switching
echo ""
echo -e "${GREEN}✅ Build successful!${NC}"
echo -e "${YELLOW}Would you like to switch to the new configuration? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🚀 Switching to new configuration...${NC}"
    sudo darwin-rebuild switch --flake .
    echo -e "${GREEN}✨ Update complete!${NC}"
    
    # Suggest committing the changes
    echo ""
    echo -e "${YELLOW}💡 Don't forget to commit the updated flake.lock:${NC}"
    echo "  git add flake.lock"
    echo "  git commit -m 'chore: update flake inputs'"
else
    echo -e "${YELLOW}⏸️  Update built but not applied. Run 'sudo darwin-rebuild switch' when ready.${NC}"
fi