# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration and user environment using Nix. The configuration supports multiple hosts with shared configurations and host-specific overrides.

## Directory Structure

```
/private/etc/nix-darwin/
├── flake.nix                 # Main entry point
├── flake.lock                # Locked dependencies
├── hosts/                    # Host configurations
│   ├── aimdevlee/           # Host-specific configuration
│   │   ├── default.nix      # Host entry point
│   │   ├── system.nix       # System overrides
│   │   └── home.nix         # Home-manager overrides
│   ├── JRXNCW6L5J/          # Another host
│   │   ├── default.nix
│   │   ├── system.nix
│   │   └── home.nix
│   └── common/              # Shared configurations
│       ├── system.nix       # Common system settings
│       └── home.nix         # Common home settings
├── programs/                 # All program modules (flat structure)
│   ├── cloud.nix           # AWS, Terraform, Kubernetes tools
│   ├── containers.nix      # Docker/Podman configuration
│   ├── dotfiles.nix        # Dotfile management
│   ├── git.nix             # Git configuration
│   ├── nix.nix             # Nix development tools
│   ├── nodejs.nix          # Node.js environment
│   ├── theme.nix           # Catppuccin theme configuration
│   └── zsh.nix             # Zsh shell configuration
├── scripts/                  # Helper scripts (added to PATH via direnv)
│   ├── rebuild              # Apply configuration to current host
│   ├── build-test           # Test build without applying
│   ├── fmt                  # Format all Nix files
│   ├── check                # Validate flake configuration
├── dotfiles/                 # Configuration files
│   ├── nvim/
│   ├── tmux/
│   ├── ghostty/
│   ├── aerospace/
│   ├── karabiner/
│   └── starship.toml
├── overlays/                 # Package overlays
│   ├── default.nix
│   ├── config.nix
│   └── unstable-packages.nix
├── lib/
│   └── utils.nix            # Minimal utility functions
└── .envrc                   # direnv configuration (loads dev environment)
```

## Configuration Flow

### 1. Entry Point: `flake.nix`
```
flake.nix
└─> mkDarwinSystem "hostname"
    └─> hosts/<hostname>/default.nix
```

### 2. Host Configuration (`hosts/<hostname>/default.nix`)
Each host:
- Imports `home-manager.darwinModules.home-manager`
- Imports `../common/system.nix` (shared system config)
- Imports `./system.nix` (host-specific overrides)
- Defines networking.hostName
- Defines users.users.<username>
- Configures home-manager to use `./home.nix`

### 3. Common Configuration
- `hosts/common/system.nix`: Shared system settings, Homebrew packages, Nix configuration
- `hosts/common/home.nix`: Shared home-manager settings, imports all programs

### 4. Program Modules (`programs/`)
Simple, flat structure with 8 modules:
- Each module is self-contained with its own options
- All modules use `programs.` namespace consistently
- Can be enabled/disabled and configured per host
- No subcategories - easy to find and maintain

## Host Configuration

### Adding a New Host

1. Create directory `hosts/<hostname>/`
2. Create `hosts/<hostname>/default.nix`:
```nix
{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common/system.nix
    ./system.nix
  ];

  networking.hostName = "<hostname>";
  
  users.users.<username> = {
    name = "<username>";
    home = "/Users/<username>";
  };

  home-manager = {
    users.<username> = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
```

3. Create `hosts/<hostname>/system.nix`:
```nix
_:
{
  homebrew.user = "<username>";
  homebrew.casks = [ /* host-specific casks */ ];
}
```

4. Create `hosts/<hostname>/home.nix`:
```nix
{ ... }:
{
  imports = [ ../common/home.nix ];
  
  programs.git.userName = "<username>";
  programs.git.userEmail = "<email>";
  
  # Host-specific overrides
}
```

5. Add to `flake.nix`:
```nix
darwinConfigurations.<hostname> = mkDarwinSystem "<hostname>";
```

## Key Commands

### Quick Commands (via scripts/)
When in the nix-darwin directory with direnv enabled:
```bash
rebuild       # Apply configuration to current host
build-test    # Test build without applying
fmt           # Format all Nix files
check         # Validate flake configuration
```

### Manual Commands
```bash
# Build and switch configuration
sudo darwin-rebuild switch --flake .#<hostname>

# Build without switching
darwin-rebuild build --flake .#<hostname>

# Update dependencies
nix flake update

# Enter development shell
nix develop

# Enable direnv (auto-loads environment and scripts)
direnv allow
```

## Important Configuration Notes

### User Configuration
- Each host defines its own user in `hosts/<hostname>/default.nix`
- Username should match the macOS user (e.g., from `echo $HOME | awk -F'/' '{print $NF}'`)
- No `system.primaryUser` needed - use `homebrew.user` in host's `system.nix`
- Each host can have different users (e.g., aimdevlee vs dongbin-lee)

### Program Configuration
Programs are configured in `hosts/common/home.nix` with host-specific overrides in `hosts/<hostname>/home.nix`:

```nix
# Common (hosts/common/home.nix)
programs = {
  nodejs = {
    enable = true;
    version = "24";
    packageManager = "npm";
  };
  cloud = {
    enable = true;
    enableAWS = true;
    enableTerraform = true;
    enableKubernetes = true;
  };
  containers = {
    enable = true;
    runtime = "podman";
    enableCompose = true;
  };
};

# Host-specific (hosts/<hostname>/home.nix)
programs.nodejs.version = "20";  # Override for this host
```

### Homebrew Configuration
- Shared packages in `hosts/common/system.nix`
- Host-specific packages in `hosts/<hostname>/system.nix`
- Each host must set `homebrew.user`
- Fonts are installed via Homebrew casks:
  - `font-udev-gothic-nf` - UDev Gothic Nerd Font
  - `font-plemol-jp-nf` - PlemolJP Nerd Font (Japanese)
  - `font-nanum-gothic-coding` - Nanum Gothic Coding (Korean)

## Module System

### Program Modules
Located in `programs/`, each module:
- Defines options for the program
- Configures packages and settings
- Can be enabled/disabled via options

Example structure:
```nix
{ config, lib, pkgs, ... }:
{
  options.programs.<name> = {
    enable = lib.mkOption { ... };
    # Other options
  };
  
  config = lib.mkIf config.programs.<name>.enable {
    # Configuration when enabled
  };
}
```

### Dotfiles Management
The `programs/dotfiles.nix` module manages configuration files:
- Sources from `dotfiles/` directory
- Links to appropriate locations in home directory
- Can be selectively enabled per config type

## CI/CD

GitHub Actions workflow runs:
- Format checking
- Flake validation
- Dead code detection
- Anti-pattern checking

## Development Workflow

### Using Helper Scripts
The `scripts/` directory contains convenience scripts that are automatically added to PATH when using direnv:

1. **rebuild**: Applies the configuration for the current host
2. **build-test**: Tests the build without applying changes
3. **fmt**: Formats all Nix files using nixfmt-rfc-style
4. **check**: Validates the flake configuration

### Typical Workflow
```bash
cd /private/etc/nix-darwin
direnv allow          # Load environment and scripts

# Make changes to configuration
vim hosts/$(hostname -s)/home.nix

# Test and apply
build-test           # Dry run to check for errors
rebuild              # Apply if successful
```

## Troubleshooting

### Common Issues

1. **"path does not exist" error**: Run `git add -A` to stage new files
2. **Homebrew user error**: Ensure `homebrew.user` is set in host's `system.nix`
3. **Build failures**: Check `nix flake check` for validation errors
4. **Scripts not found**: Run `direnv allow` to load the environment
5. **Pre-commit hook failures**: 
   - Run `fmt` to fix formatting issues
   - Check for unused variables with deadnix
   - Use `_` for empty patterns instead of `{ ... }`
   - Merge repeated attribute assignments

### Debug Commands
```bash
# Show flake outputs
nix flake show

# Check specific host
nix build .#darwinConfigurations.<hostname>.system --dry-run

# View logs
nix log /nix/store/<hash>-<name>.drv
```

## Notes

- Configuration uses experimental flakes feature
- All paths in Nix files should be relative
- Homebrew cleanup is disabled by default (can enable with `cleanup = "zap"`)
- Git working tree must be clean or staged for flake to see changes
- Simple flat structure in `programs/` - only 8 files, no subcategories
- Each host has its own user configuration - no shared user assumptions

## Code Style Guidelines

### Nix Best Practices
- Use `_` for unused function parameters instead of `{ ... }`
- Avoid unused imports (lib, pkgs) in function arguments
- Group related attributes using nested sets instead of repeated keys
- Use `inherit` syntax when appropriate
- Remove concatenation with empty lists `[]`

### Validation Tools
The `check` script runs:
- **deadnix**: Detects unused Nix code
- **nixfmt-rfc-style**: Enforces consistent formatting
- **statix**: Suggests idiomatic Nix patterns
