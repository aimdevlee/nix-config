# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration and user environment using Nix. The configuration is modularized for better maintainability and supports both Darwin and Linux systems.

## Key Commands

### Rebuild System Configuration
```bash
sudo darwin-rebuild switch
```
Or use the alias:
```bash
ns
```

### Build Configuration (without applying)
```bash
darwin-rebuild build --flake .
```

### Format Nix Files
```bash
nixfmt-rfc-style <file.nix>
```

### Update Flake Inputs
```bash
nix flake update
```

### Check Flake
```bash
nix flake check
```

## Architecture

### Directory Structure
```
/private/etc/nix-darwin/
├── flake.nix                 # Main entry point
├── flake.lock                # Locked dependencies
├── lib/
│   └── default.nix           # Shared constants, theme colors, system detection
├── modules/
│   ├── user.nix             # User configuration module
│   ├── theme.nix            # Centralized theme management
│   └── development.nix      # Development tools and aliases
└── hosts/
    └── aimdevlee/
        ├── default.nix       # Host-specific configuration
        ├── configuration.nix # System-wide settings and Homebrew
        └── home-manager/
            ├── home.nix      # User configuration (imports modules)
            └── config/       # Application dotfiles
```

### Modular System

#### Core Modules (`modules/`)
- **user.nix**: Manages user information (name, email, home directory), Git configuration
- **theme.nix**: Centralized Catppuccin Mocha theme, font configuration, Starship prompt theming
- **development.nix**: Development tools, LSP servers, shell aliases, environment variables

#### Shared Library (`lib/default.nix`)
- System detection (Darwin vs Linux)
- User constants (name, email, paths)
- Theme colors (Catppuccin Mocha palette)
- Font configurations
- Cross-platform compatibility helpers

### Key Design Patterns
1. **Modular Configuration**: Functionality separated into reusable modules
2. **Central Constants**: All hardcoded values in `lib/default.nix`
3. **System Detection**: Automatic Darwin/Linux detection for cross-platform support
4. **Separation of Concerns**: System (configuration.nix) vs User (home.nix) settings
5. **Homebrew Integration**: GUI apps via Homebrew, CLI tools via Nix
6. **Config Symlinking**: Dotfiles in `home-manager/config/` symlinked to `~/.config/`

### Package Management
- **Nix Packages**: Development tools and CLI utilities (managed by modules)
- **Homebrew Casks**: GUI applications (VS Code, Discord, Ghostty, etc.)
- **Homebrew Brews**: macOS-specific CLI tools (claude-squad)
- **Unstable Channel**: Available via `unstable-pkgs` for newer versions

### Module Configuration
Modules are enabled in `home.nix`:
```nix
modules = {
  user.enable = true;
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

## Development Aliases
Key aliases configured in `development.nix`:
- Git: `g`, `gs`, `ga`, `gc`, `gp`, `gpl`, `gco`, `gb`
- Directory: `ls` (eza), `ll`, `la`, `lt`
- Nix: `ns` (rebuild), `nfu` (update), `nfc` (check)
- Tools: `v` (nvim), `t` (tmux), `ta`, `tn`
- Special: `claude` (Claude Code CLI)

## Important Notes
- The `result` symlink (build output) is gitignored
- Configuration uses experimental flakes feature
- Homebrew has aggressive cleanup (`cleanup = "zap"`)
- Theme module dynamically generates Starship configuration
- All user-specific values reference `lib/default.nix` constants
- System automatically detects Darwin vs Linux for compatibility