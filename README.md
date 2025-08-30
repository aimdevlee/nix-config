# 🍎 Nix-Darwin Configuration

A declarative macOS system configuration using [Nix](https://nixos.org/) and [nix-darwin](https://github.com/LnL7/nix-darwin), featuring profile-based environments for seamless context switching between personal and work setups.

## ✨ Features

- **🔄 Profile-Based Configuration**: Easily switch between personal and work environments
- **📦 Declarative Package Management**: All tools and dependencies defined in code
- **🎨 Consistent Theming**: Catppuccin theme across all applications
- **🚀 Developer-Focused**: Pre-configured development tools and LSPs
- **🔧 Modular Architecture**: Clean separation of concerns with organized modules
- **🤖 Interactive Setup**: User-friendly profile selection on first use

## 📋 Prerequisites

- macOS (Apple Silicon or Intel)
- Command Line Tools: `xcode-select --install`

## 🚀 Quick Start

### 1. Install Nix

```bash
# Nix installer
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone Repository

```bash
# Clone to the expected location
sudo git clone https://github.com/aimdevlee/nix-darwin /etc/nix-darwin
cd /etc/nix-darwin
```

### 3. Initial Setup

```bash
# Enable flakes and nix-command
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch
```

### 5. Enable Interactive Environment

```bash
# Allow direnv in the repository
cd /etc/nix-darwin
direnv allow

# You'll be prompted to select a profile interactively
```

## 👤 Profile System

This configuration uses a **profile-based system** instead of host-specific configurations, allowing you to maintain separate environments on the same machine.

### Available Profiles

| Profile | Description |
|---------|-------------|
| `personal` | Personal development environment with all tools |
| `work` | Work environment with organization-specific settings |

### Interactive Profile Selection

When you first enter the directory with direnv:

```
🔧 Nix-Darwin Profile Selection
================================
Current user: your-username

Please select your profile:
1) personal - Personal development environment
2) work     - Work environment
3) skip     - Don't set a profile now

Enter your choice (1-3): 
```

Your selection can be saved permanently or used for the current session only.

## 📁 Repository Structure

```
/etc/nix-darwin/
├── flake.nix                 # Entry point and flake definition
├── flake.lock               # Locked dependencies
├── hosts/
│   ├── profiles/           # Profile configurations
│   │   ├── personal/      # Personal environment
│   │   └── work/          # Work environment
│   └── common/            # Shared configurations
├── programs/               # Program modules (flat structure)
│   ├── cloud.nix         # AWS, Terraform, K8s tools
│   ├── containers.nix    # Docker/Podman setup
│   ├── git.nix          # Git and related tools
│   ├── lsp.nix          # Language servers
│   ├── nodejs.nix       # Node.js environment
│   ├── shell-essentials.nix # Core utilities
│   └── zsh.nix          # Shell configuration
├── dotfiles/              # Application configurations
│   ├── nvim/            # Neovim configuration
│   ├── tmux/            # Tmux configuration
│   └── ghostty/         # Terminal configuration
├── scripts/              # Helper scripts
└── overlays/            # Package overlays
```

## 🛠️ Usage

### Daily Commands

Once direnv is set up, convenient scripts are available:

```bash
# Apply current profile configuration
rebuild

# Switch to specific profile
rebuild-personal
rebuild-work

# Test changes without applying
build-test

# Format all Nix files
fmt

# Validate configuration
check
```

### Profile Management

```bash
# Switch profile temporarily
TARGET=work direnv reload

# Change default profile
rm .envrc.local
direnv reload  # Interactive selection

# Manual profile switch
sudo darwin-rebuild switch --flake .#personal
sudo darwin-rebuild switch --flake .#work
```

### Package Management

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Search for packages
nix search nixpkgs neovim
```

## 🔧 Configuration

### Adding Packages

Edit the appropriate module in `programs/` or add to system packages:

```nix
# In programs/shell-essentials.nix
home.packages = with pkgs; [
  your-package
];

# Or in hosts/common/system.nix for Homebrew casks
homebrew.casks = [
  "your-cask"
];
```

### Customizing Profiles

Each profile can override common settings:

```nix
# hosts/profiles/personal/home.nix
{
  imports = [ ../../common/home.nix ];
  
  # Profile-specific overrides
  programs.git.userEmail = "personal@email.com";
  programs.nodejs.version = "20";
}
```

### Program Modules

Enable/disable features through module options:

```nix
programs = {
  # Core utilities
  shellEssentials.enable = true;
  
  # Development tools
  lsp = {
    enable = true;
    languages = ["typescript" "go" "rust"];
  };
  
  # Cloud tools
  cloud = {
    enable = true;
    enableAWS = true;
    enableKubernetes = true;
  };
};
```

## 📦 Included Software

### Development Tools
- **Editors**: Neovim (with LSP configuration)
- **Languages**: Node.js, Go, Rust, Python
- **Version Control**: Git, GitHub CLI, Lazygit
- **Containers**: Docker/Podman, Docker Compose

### Shell & Terminal
- **Shell**: Zsh with Oh-My-Zsh
- **Terminal**: Ghostty, Alacritty
- **Multiplexer**: Tmux
- **Utilities**: ripgrep, fd, bat, eza, fzf, zoxide

### Cloud & Infrastructure
- **AWS**: AWS CLI, SAM CLI
- **Kubernetes**: kubectl, k9s, helm
- **IaC**: Terraform, Pulumi

### System Tools
- **Window Manager**: Aerospace
- **Package Manager**: Homebrew (for GUI apps)
- **Font**: UDev Gothic NF, PlemolJP NF

## 🔍 Troubleshooting

### Common Issues

#### "path does not exist" error
```bash
# Stage new files before building
git add -A
```

#### Profile not loading
```bash
# Reload direnv
direnv reload

# Or re-allow after changes
direnv allow
```

#### Build failures
```bash
# Check for errors
nix flake check

# View detailed logs
nix build .#darwinConfigurations.personal.system --show-trace
```

#### Scripts not found
```bash
# Ensure direnv is loaded
direnv allow

# Check if in correct directory
pwd  # Should be /etc/nix-darwin
```

### Reset Configuration

```bash
# Reset to clean state
rm .envrc.local
direnv reload

# Full rebuild
sudo darwin-rebuild switch --flake .#personal --impure
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run validation:
   ```bash
   fmt      # Format code
   check    # Validate configuration
   ```
5. Submit a pull request

## 📚 Resources

- [Nix-Darwin Documentation](https://daiderd.com/nix-darwin/)
- [Nix-Darwin GitHub (Apple Silicon)](https://github.com/nix-darwin/nix-darwin)
- [Nix-Darwin GitHub (Intel)](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 📄 License

This configuration is provided as-is for personal and educational use.

## 🙏 Acknowledgments

- [nix-darwin](https://github.com/nix-darwin/nix-darwin) (Apple Silicon) / [nix-darwin](https://github.com/LnL7/nix-darwin) (Intel) for macOS Nix integration
- [home-manager](https://github.com/nix-community/home-manager) for user environment management
- The Nix community for extensive documentation and support

---

<p align="center">
  Built with ❄️ Nix | Managed with 🍎 nix-darwin
</p>
