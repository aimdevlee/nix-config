# Common home-manager configuration for all hosts
{ pkgs, ... }:
{
  imports = [
    # Import all common programs
    ../../programs/zsh.nix
    ../../programs/git.nix
    ../../programs/theme.nix
    ../../programs/dotfiles.nix
    ../../programs/nodejs.nix
    ../../programs/nix.nix
    ../../programs/cloud.nix
    ../../programs/containers.nix
  ];

  # Common program configurations
  programs = {
    # Enable zsh with completions
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Git configuration
    git = {
      enable = true;
      # userName is set in host-specific home.nix
      # userEmail is set in host-specific home.nix
    };

    # Theme configuration
    starship.enable = true;

    # Enable programs
    nodejs = {
      enable = true;
      version = "24";
      packageManager = "npm";
    };

    nix.enableTools = true;
    nix.enableLSP = true;

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

    dotfiles.enable = true;
  };

  # Common packages for all hosts
  home = {
    packages = with pkgs; [
      # Core utilities
      ripgrep
      fd
      bat
      eza
      fzf
      jq
      yq
      tree
      wget
      curl
      htop

      # Development tools
      gh
      delta
      lazygit
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };

    # Home state version
    stateVersion = "25.05";
  };
}
