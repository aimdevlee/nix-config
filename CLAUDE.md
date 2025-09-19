# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration and user environment using Nix. The configuration supports multiple hosts with shared configurations and host-specific overrides.

## Directory Structure

```
/private/etc/nix-darwin/
├── flake.nix                 # Main entry point
├── flake.lock                # Locked dependencies
├── hosts/                    # Profile configurations
│   ├── profiles/            # Profile-based configurations (no host names)
│   │   ├── personal/        # Personal environment
│   │   │   ├── default.nix  # Profile entry point
│   │   │   ├── system.nix   # System overrides
│   │   │   └── home.nix     # Home-manager overrides
│   │   └── work/            # Work environment
│   │       ├── default.nix
│   │       ├── system.nix
│   │       └── home.nix
│   └── common/              # Shared configurations
│       ├── system.nix       # Common system settings
│       └── home.nix         # Common home settings
├── programs/                 # All program modules (flat structure)
│   ├── cloud.nix           # AWS, Terraform, Kubernetes tools
│   ├── containers.nix      # Docker/Podman configuration
│   ├── dotfiles.nix        # Dotfile management
│   ├── git.nix             # Git configuration and tools (gh, lazygit, etc.)
│   ├── lsp.nix             # Language Server Protocol servers
│   ├── nix.nix             # Nix development tools
│   ├── nodejs.nix          # Node.js environment
│   ├── shell-essentials.nix # Core shell utilities (ripgrep, fd, bat, etc.)
│   └── zsh.nix             # Zsh shell configuration
├── scripts/                  # Helper scripts (added to PATH via direnv)
│   ├── rebuild              # Apply configuration (TARGET=personal|work)
│   ├── rebuild-personal     # Apply personal profile
│   ├── rebuild-work         # Apply work profile
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
├── config/                   # Additional configuration files
├── data/                     # Data files
└── .envrc                   # direnv configuration (loads dev environment)
```

## Configuration Flow

### 1. Entry Point: `flake.nix`
```
flake.nix
└─> mkDarwinSystem "profile"
    └─> hosts/profiles/<profile>/default.nix
```

### 2. Profile Configuration (`hosts/profiles/<profile>/default.nix`)
Each host:
- Imports `home-manager.darwinModules.home-manager`
- Imports `../../common/system.nix` (shared system config)
- Imports `./system.nix` (profile-specific overrides)
- Defines users.users.<username> (different per profile)
- Configures home-manager to use `./home.nix`
- NO networking.hostName (uses machine's actual hostname)

### 3. Common Configuration
- `hosts/common/system.nix`: Shared system settings, Homebrew packages, Nix configuration
- `hosts/common/home.nix`: Shared home-manager settings, imports all programs

### 4. Program Modules (`programs/`)
Simple, flat structure with 9 modules:
- Each module is self-contained with its own options
- All modules use `programs.` namespace consistently
- Can be enabled/disabled and configured per host
- Packages are organized by function, not by usage category

## Profile Configuration

### Profile-Based System

This configuration uses **profiles** instead of host names:
- **personal**: Personal development environment (user: aimdevlee)
- **work**: Work environment (user: dongbin-lee)

No actual machine hostnames are used in the configuration.

### Adding a New Profile

1. Create directory `hosts/profiles/<profile>/`
2. Create `hosts/profiles/<profile>/default.nix`:
```nix
{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../common/system.nix
    ./system.nix
  ];

  # NO networking.hostName - uses machine's actual hostname
  
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

3. Create `hosts/profiles/<profile>/system.nix`:
```nix
_:
{
  homebrew.user = "<username>";
  homebrew.casks = [ /* profile-specific casks */ ];
}
```

4. Create `hosts/profiles/<profile>/home.nix`:
```nix
{ ... }:
{
  imports = [ ../../common/home.nix ];
  
  programs.git.userName = "<username>";
  programs.git.userEmail = "<email>";
  
  # Profile-specific overrides
}
```

5. Add to `flake.nix`:
```nix
darwinConfigurations.<profile> = mkDarwinSystem "<profile>";
```

## Key Commands

### Quick Commands (via scripts/)
When in the nix-darwin directory with direnv enabled:
```bash
# Profile-based rebuild
TARGET=personal rebuild  # Apply personal profile
TARGET=work rebuild      # Apply work profile  
rebuild                  # Apply default (personal) profile

# Shortcut scripts
rebuild-personal        # Apply personal profile
rebuild-work            # Apply work profile

# Other commands
build-test              # Test build without applying
fmt                     # Format all Nix files
check                   # Validate flake configuration
```

### Manual Commands
```bash
# Build and switch configuration
sudo darwin-rebuild switch --flake .#personal   # Personal profile
sudo darwin-rebuild switch --flake .#work       # Work profile

# Build without switching
darwin-rebuild build --flake .#personal  # Test personal profile
darwin-rebuild build --flake .#work      # Test work profile

# Update dependencies
nix flake update

# Enter development shell
nix develop

# Enable direnv (auto-loads environment and scripts)
direnv allow
```

### Zoxide Usage (after configuration is applied)
```bash
# Jump to a frequently used directory
z <partial-name>

# Interactive selection with fzf
zi

# Add current directory to zoxide database
z add .

# Query zoxide database
z query <partial-name>
```

## Important Configuration Notes

### User Configuration
- Each profile defines its own user in `hosts/profiles/<profile>/default.nix`
- **personal profile**: user `aimdevlee`
- **work profile**: user `dongbin-lee`
- No `system.primaryUser` needed - use `homebrew.user` in profile's `system.nix`
- Profiles are machine-independent (no hostname configuration)

### Program Configuration
Programs are configured in `hosts/common/home.nix` with profile-specific overrides in `hosts/profiles/<profile>/home.nix`:

```nix
# Common (hosts/common/home.nix)
programs = {
  # Core utilities - everyone needs these
  shellEssentials.enable = true;
  
  # Language servers for development
  lsp = {
    enable = true;
    languages = ["lua" "typescript" "go" "nix"];
  };
  
  # Development tools
  nodejs = {
    enable = true;
    version = "24";
    packageManager = "npm";
  };
  
  # Git with tools
  git = {
    enable = true;
    # Includes gh, lazygit, gitleaks
  };
  
  # Cloud tools
  cloud = {
    enable = true;
    enableAWS = true;
    enableTerraform = true;
    enableKubernetes = true;
  };
  
  # Container runtime
  containers = {
    enable = true;
    runtime = "podman";
    enableCompose = true;
  };
};

# Profile-specific (hosts/profiles/<profile>/home.nix)
programs.nodejs.version = "20";  # Override for this profile
programs.lsp.languages = ["typescript" "go"];  # Customize LSPs per profile
```

### Homebrew Configuration
- Shared packages in `hosts/common/system.nix`
- Profile-specific packages in `hosts/profiles/<profile>/system.nix`
- Each profile must set `homebrew.user`
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
- Manages related packages together

Example structure:
```nix
{ config, lib, pkgs, ... }:
{
  options.programs.<name> = {
    enable = lib.mkOption { ... };
    # Other options
  };
  
  config = lib.mkIf config.programs.<name>.enable {
    home.packages = with pkgs; [
      # Related packages for this module
    ];
    # Other configuration
  };
}
```

### Package Management Strategy
- **All packages are managed through home-manager** (no system-level packages)
- **Modular organization**: Related packages stay together
  - `shell-essentials.nix`: Core utilities (ripgrep, fd, bat, eza, fzf, etc.)
  - `lsp.nix`: Language servers with configurable language support
  - `git.nix`: Git and related tools (gh, lazygit, gitleaks)
  - `nix.nix`: Nix development tools (nixfmt, deadnix, statix)
- **No usage-based categorization**: Packages grouped by function, not purpose
- **Profile flexibility**: Each profile can override module settings or disable modules entirely

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
vim hosts/profiles/<profile>/home.nix

# Test and apply
build-test           # Dry run to check for errors
rebuild              # Apply if successful (uses TARGET env var)
```

## Troubleshooting

### Common Issues

1. **"path does not exist" error**: Run `git add -A` to stage new files
2. **Homebrew user error**: Ensure `homebrew.user` is set in profile's `system.nix`
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

# Check specific profile
nix build .#darwinConfigurations.personal.system --dry-run
nix build .#darwinConfigurations.work.system --dry-run

# View logs
nix log /nix/store/<hash>-<name>.drv
```

## Notes

- Configuration uses experimental flakes feature
- All paths in Nix files should be relative
- Homebrew cleanup is disabled by default (can enable with `cleanup = "zap"`)
- Git working tree must be clean or staged for flake to see changes
- Simple flat structure in `programs/` - 9 focused modules, no subcategories
- Uses nixpkgs-unstable directly without overlay system for simplicity
- Each profile has its own user configuration - personal vs work separation
- Profile-based configuration - no machine hostnames in configuration

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
