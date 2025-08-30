# Common home-manager configuration for all hosts
{ pkgs, ... }:
{
  imports = [
    # Import all common programs
    ../../programs/shell-essentials.nix
    ../../programs/lsp.nix
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
    # Core utilities - everyone needs these
    shellEssentials.enable = true;

    # Language servers for development
    lsp = {
      enable = true;
      languages = [
        "lua"
        "typescript"
        "go"
        "nix"
      ];
    };

    # Enable zsh with completions
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = '''';
    };

    # Git configuration
    git = {
      enable = true;
      enableDelta = true;
      enableLazygit = true;
      # userName is set in host-specific home.nix
      # userEmail is set in host-specific home.nix
    };

    # Theme configuration
    starship.enable = true;

    # Enable direnv for automatic environment loading
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true; # Better Nix integration with caching
    };

    # Enable programs
    nodejs = {
      enable = true;
      version = "24";
      packageManager = "npm";
    };

    nix.enableTools = true;

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

    # GPG configuration
    gpg = {
      enable = true;
      settings = {
        use-agent = true;
      };
    };
  };

  # Home configuration
  home = {
    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };

    # Home state version
    stateVersion = "25.05";
  };

  xdg = {
    enable = true;
  };
}
