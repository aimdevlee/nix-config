# Overlay configuration - packages to use from unstable channel
{
  # All packages that should use unstable versions
  packages = [
    # Development tools
    "gh" # GitHub CLI
    "nil" # Nix LSP
    "lua-language-server"
    "qmk"
    "neovim"

    # Terminal tools
    "tmux"
    "eza"
    "zoxide"

    # Cloud tools
    "awscli2"

    # Container tools
    "colima"
    "docker-compose"
    "docker"

    # Node.js versions (all versions from unstable)
    "nodejs_20"
    "nodejs_22"
    "nodejs_24"
  ];
}
