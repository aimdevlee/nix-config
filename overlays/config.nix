# Overlay configuration
# Define which packages should use unstable versions
{
  # Development tools that benefit from latest features
  development = [
    "gh" # GitHub CLI updates frequently
    "nil" # Nix LSP
    "lua-language-server"
    "qmk"
  ];

  # Node.js ecosystem
  nodejs = {
    version = "nodejs_24"; # Specific Node.js version from unstable
  };

  # Terminal tools with frequent updates
  terminal = [
    "tmux" # Terminal multiplexer
    "eza" # Modern ls replacement
    "zoxide" # Smart cd
  ];

  # Cloud and container tools that need latest APIs
  cloud = [
    "awscli2" # AWS CLI v2
  ];

  # Container tools
  containers = [
    "colima" # Container runtime
    "docker-compose" # Compose for colima
    "docker"
  ];

  # Additional packages can be added here
  # Format: either a list of package names or an attrset with special handling
}
