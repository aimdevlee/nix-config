#!/usr/bin/env bash
# Backup script for nix-darwin configuration
# Creates a backup of current configuration and important files

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$HOME/.config/nix-darwin-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backup_${TIMESTAMP}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo -e "${BLUE}💾 Nix-Darwin Configuration Backup${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found. Please run from the nix-darwin directory.${NC}"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}📦 Creating backup at: ${BACKUP_PATH}${NC}"
mkdir -p "$BACKUP_PATH"

# Backup current configuration
echo -e "${YELLOW}  Backing up configuration files...${NC}"
cp -r flake.nix flake.lock "$BACKUP_PATH/"
cp -r hosts modules lib overlays "$BACKUP_PATH/" 2>/dev/null || true
cp -r scripts "$BACKUP_PATH/" 2>/dev/null || true
cp CLAUDE.md "$BACKUP_PATH/" 2>/dev/null || true

# Backup .gitignore if it exists
if [ -f ".gitignore" ]; then
    cp .gitignore "$BACKUP_PATH/"
fi

# Create a system information file
echo -e "${YELLOW}  Saving system information...${NC}"
cat > "$BACKUP_PATH/system-info.txt" << EOF
Backup created: $(date)
Hostname: $(hostname)
Darwin version: $(sw_vers -productVersion)
Nix version: $(nix --version)

Current Git commit:
$(git rev-parse HEAD 2>/dev/null || echo "Not in a git repository")

Current Git branch:
$(git branch --show-current 2>/dev/null || echo "Not in a git repository")

Flake inputs:
$(nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | "\(.key): \(.value.locked.rev // "N/A")"' 2>/dev/null || echo "Could not retrieve flake metadata")
EOF

# Create restore script
echo -e "${YELLOW}  Creating restore script...${NC}"
cat > "$BACKUP_PATH/restore.sh" << 'EOF'
#!/usr/bin/env bash
# Restore script for this backup

set -euo pipefail

echo "⚠️  This will restore the nix-darwin configuration from this backup."
echo "Current configuration will be overwritten!"
echo ""
echo "Are you sure you want to continue? (yes/no)"
read -r response

if [ "$response" != "yes" ]; then
    echo "Restore cancelled."
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy files back
echo "Restoring configuration..."
sudo cp -r "$SCRIPT_DIR"/* /private/etc/nix-darwin/
echo "✅ Configuration restored from backup"
echo ""
echo "Run 'sudo darwin-rebuild switch' to apply the restored configuration"
EOF
chmod +x "$BACKUP_PATH/restore.sh"

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)

# Keep only the last 5 backups
echo -e "${YELLOW}  Cleaning old backups (keeping last 5)...${NC}"
ls -t "$BACKUP_DIR" | tail -n +6 | while read -r old_backup; do
    rm -rf "${BACKUP_DIR}/${old_backup}"
    echo -e "${YELLOW}    Removed old backup: ${old_backup}${NC}"
done

echo ""
echo -e "${GREEN}✅ Backup complete!${NC}"
echo -e "${BLUE}  Location: ${BACKUP_PATH}${NC}"
echo -e "${BLUE}  Size: ${BACKUP_SIZE}${NC}"
echo ""
echo -e "${YELLOW}💡 To restore from this backup, run:${NC}"
echo -e "  ${BACKUP_PATH}/restore.sh"