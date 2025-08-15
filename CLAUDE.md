# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration and user environment using Nix. The configuration is highly modularized for better maintainability and supports both Darwin and Linux systems.

## Key Commands

### Quick Commands
```bash
# Rebuild and apply system configuration
ns                    # Alias for sudo darwin-rebuild switch

# Development and maintenance
./scripts/check.sh    # Run all validation checks
./scripts/update.sh   # Update flake inputs
./scripts/backup.sh   # Backup configuration

# Nix commands
nix fmt              # Format all .nix files
nix flake check      # Validate flake configuration
nix develop          # Enter development shell
```

### System Management
```bash
# Build configuration (without applying)
darwin-rebuild build --flake .

# Switch to new configuration
sudo darwin-rebuild switch --flake .

# Update specific flake input
nix flake update <input-name>
```

## Architecture

### Directory Structure
```
/private/etc/nix-darwin/
├── flake.nix                 # Main entry point with formatter, devShell, checks
├── flake.lock                # Locked dependencies
├── lib/
│   └── default.nix           # Shared constants, theme colors, system detection
├── modules/
│   ├── core/                 # Core system modules
│   │   ├── user.nix         # User configuration, Git settings
│   │   └── theme.nix        # Catppuccin theme, Starship prompt
│   ├── languages/            # Language-specific configurations
│   │   └── nodejs.nix       # Node.js environment
│   ├── tools/                # Development tools
│   │   ├── git.nix          # Git configuration and aliases
│   │   ├── nix.nix          # Nix development tools
│   │   ├── cloud.nix        # AWS, Terraform, Kubernetes
│   │   └── containers.nix   # Docker/Podman configuration
│   ├── shell/                # Shell configurations
│   │   ├── aliases.nix      # Command aliases
│   │   └── environment.nix  # Environment variables
│   └── development.nix       # Aggregator module for backward compatibility
├── overlays/
│   ├── default.nix           # Main overlay configuration
│   └── unstable-packages.nix # Selective unstable package usage
├── hosts/
│   └── aimdevlee/
│       ├── default.nix       # Host-specific configuration
│       ├── configuration.nix # System-wide settings and Homebrew
│       └── home-manager/
│           ├── home.nix      # User configuration (imports modules)
│           └── config/       # Application dotfiles
├── scripts/                  # Maintenance scripts
│   ├── check.sh             # Validation script
│   ├── update.sh            # Update helper
│   └── backup.sh            # Backup utility
└── .github/
    └── workflows/
        └── ci.yml            # CI/CD pipeline

```

### Modular System

#### Core Modules (`modules/core/`)
- **user.nix**: User info, Git configuration, SSH signing
- **theme.nix**: Catppuccin Mocha theme, fonts, Starship prompt

#### Language Modules (`modules/languages/`)
- **nodejs.nix**: Node.js versions, package managers, aliases

#### Tool Modules (`modules/tools/`)
- **git.nix**: Git tools, GitHub CLI, delta diff viewer
- **nix.nix**: Nix LSP, formatters, linters
- **cloud.nix**: AWS CLI, Terraform, Kubernetes tools
- **containers.nix**: Docker/Podman runtime and compose

#### Shell Modules (`modules/shell/`)
- **aliases.nix**: Command shortcuts, eza integration
- **environment.nix**: Environment variables, XDG specs

### Key Design Patterns

1. **Modular Configuration**: Each module can be independently enabled/configured
2. **Overlay System**: Selective use of unstable packages via overlays
3. **Central Constants**: All hardcoded values in `lib/default.nix`
4. **Cross-Platform Support**: Automatic Darwin/Linux detection
5. **Backward Compatibility**: `development.nix` maintains old option structure
6. **CI/CD Integration**: GitHub Actions for validation and quality checks

### Package Management
- **Nix Packages**: Development tools and CLI utilities (via modules)
- **Unstable Overlay**: Latest versions for frequently updated tools
- **Homebrew Casks**: GUI applications (VS Code, Discord, etc.)
- **Homebrew Brews**: macOS-specific CLI tools

### Module Configuration
Modules are enabled in `home.nix`:
```nix
modules = {
  user = {
    enable = true;
    enableGitSigning = true;
  };
  theme.enable = true;
  development = {
    enable = true;
    enableNodejs = true;
    enableNix = true;
    enableLsp = true;
    enableCloud = true;
    enableContainers = true;
  };
};
```

Fine-grained control is available for new modules:
```nix
modules.languages.nodejs = {
  enable = true;
  version = "24";
  packageManager = "npm";
};

modules.tools.git = {
  enable = true;
  enableGitHub = true;
  enableDelta = false;
};
```

## Development Workflow

### Using the Development Shell
```bash
# Enter development shell with all tools
nix develop

# Or use direnv (if .envrc is allowed)
direnv allow
```

### Running Checks
```bash
# Run all validation checks locally
./scripts/check.sh

# Individual checks
nix fmt -- --check .       # Format check
nix flake check           # Flake validation
deadnix --fail .          # Dead code check
statix check .            # Anti-pattern check
```

### Updating Dependencies
```bash
# Interactive update with rebuild option
./scripts/update.sh

# Manual update
nix flake update
darwin-rebuild build --flake .
sudo darwin-rebuild switch --flake .
```

## CI/CD Pipeline

GitHub Actions workflow (`ci.yml`) runs:
- **validate**: Format and flake checks
- **quality**: Dead code and anti-pattern detection
- **dependencies**: Flake input analysis
- **security**: Secret scanning
- **build-darwin**: macOS build test (on schedule or [build] tag)

## Important Notes
- The `result` symlink (build output) is gitignored
- Configuration uses experimental flakes feature
- Homebrew has aggressive cleanup (`cleanup = "zap"`)
- All user-specific values reference `lib/default.nix` constants
- Overlays manage stable/unstable package selection
- Pre-commit hooks enforce code quality

## Development Aliases
Key aliases configured across modules:
- Git: `g`, `gs`, `ga`, `gc`, `gp`, `gpl`, `gco`, `gb`
- Directory: `ls` (eza), `ll`, `la`, `lt`
- Nix: `ns` (rebuild), `nfu` (update), `nfc` (check), `nfmt` (format)
- Tools: `v` (nvim), `t` (tmux), `ta`, `tn`
- Containers: `d` (docker/podman), `dc` (compose)
- Cloud: `k` (kubectl), AWS shortcuts
- Special: `claude` (Claude Code CLI)

## Extending the Configuration

### Adding a New Module
1. Create module file in appropriate directory
2. Define options with `lib.mkOption`
3. Implement config with `lib.mkIf`
4. Import in `development.nix` or directly in `home.nix`

### Adding Unstable Packages
1. Edit `overlays/unstable-packages.nix`
2. Add package: `packageName = unstable.packageName;`
3. Rebuild system

### Adding GUI Applications
1. Edit `hosts/aimdevlee/configuration.nix`
2. Add to `homebrew.casks` list
3. Run `sudo darwin-rebuild switch`