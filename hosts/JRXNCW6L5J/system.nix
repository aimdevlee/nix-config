# Host-specific system configuration for JRXNCW6L5J
_: {
  homebrew = {
    # Homebrew user for this host
    user = "dongbin-lee";

    # Host-specific Homebrew packages
    brews = [
      # Shell & Terminal
      "tmux"
      "neofetch"
      "screenresolution"
      "tpm" # Tmux plugin manager

      # Development Tools
      "git"
      "gh" # GitHub CLI
      "lazygit"
      "neovim"
      "watchman"
      "gitleaks" # Security scanning

      # Search & Navigation
      "ripgrep"
      "fd"
      "fzf"
      "eza" # Modern ls replacement
      "zoxide" # Smart cd

      # Container & Virtualization
      "colima" # Container runtime
      "docker"
      "docker-compose"
      "docker-completion"
      "dockerize"
      "lima" # Linux VMs
      "qemu"

      # Cloud & Infrastructure
      "awscli"
      "saml2aws" # AWS SAML authentication
      "sops" # Secret management

      # Shell Enhancements
      "starship" # Shell prompt
      "direnv"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"

      # Package Management
      "asdf" # Version manager

      # Database
      "mysql@8.0"

      # AI Tools
      "ollama"

      # Node.js
      "node"

      # Language Servers
      "gopls" # Go language server
      "vscode-langservers-extracted" # Web development language servers

      # Security
      "gnupg"
      "pinentry-mac"
    ];

    casks = [
      # Database GUI
      "sequel-ace"
    ];
  };

  # Host-specific system settings
  # system.defaults.dock.autohide = false;

  # Note: The following casks are already in common/system.nix:
  # - aerospace
  # - font-nanum-gothic-coding
  # - font-plemol-jp-nf
  # - font-udev-gothic-nf
  # - ghostty@tip
  # - karabiner-elements
  # - raycast
  # - visual-studio-code
}
