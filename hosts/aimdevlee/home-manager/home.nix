# User-specific configuration for "aimdevlee" managed by home-manager.
# Refactored to use modular configuration
{
  pkgs,
  ...
}:
{
  # Import modular configurations
  imports = [
    ../../../modules/core/user.nix
    ../../../modules/core/theme.nix
    ../../../modules/development.nix
  ];

  # Enable modules
  modules = {
    user = {
      enable = true;
      enableGitSigning = true; # Enable SSH signing for commits
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

  # Additional packages not covered by modules
  home.packages = with pkgs; [
    # Add any additional packages here that aren't in modules
  ];

  # Additional environment variables
  # Note: Most environment variables are handled by modules/shell/environment.nix
  home.sessionVariables = {
    # Add any host-specific environment variables here
  };

  # Link config files to their correct locations
  # These are the actual configuration files that applications read
  home.file = {
    ".config/starship/starship.toml".source = ./config/starship/starship.toml;
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
    ".config/ghostty" = {
      source = ./config/ghostty;
      recursive = true;
    };
    ".config/aerospace/aerospace.toml".source = ./config/aerospace/aerospace.toml;
    ".config/karabiner" = {
      source = ./config/karabiner;
      recursive = true;
    };
    ".config/tmux/tmux.conf".source = ./config/tmux/tmux.conf;
  };

  # Program-specific configurations
  programs = {
    home-manager.enable = true;
    neovim.enable = true;

    # Note: Git is configured by the user module
    # Note: Starship is configured by the theme module
    # Note: Zoxide is configured by the development module

    zsh = {
      enable = true;
      initContent = ''
        # Initialize Homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
      # Additional aliases not in development module
      shellAliases = {
        claude = "npx @anthropic-ai/claude-code";
      };
    };
  };

  # Set the state version for home-manager
  home.stateVersion = "25.05";
}
