# Common home-manager configuration for all hosts
{ pkgs, ... }:
{
  imports = [
    # Import all common programs
    ../../programs/shell-essentials.nix
    ../../programs/lsp.nix
    ../../programs/zsh.nix
    ../../programs/git.nix
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
      initContent = ''
        # FZF configuration
        export FZF_DEFAULT_OPTS="
        --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
        --color=border:#44415a,header:#3e8fb0,gutter:#232136
        --color=spinner:#f6c177,info:#9ccfd8
        --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
        FD_OPTS="--hidden --follow --strip-cwd-prefix --exclude .git"
        export FZF_DEFAULT_COMMAND="fd --type=f $FD_OPTS"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        bindkey "ç" fzf-cd-widget
        export FZF_ALT_C_COMMAND="fd --type=d $FD_OPTS"
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

        # Source local configuration if exists (contains sensitive functions)
        [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
      '';
    };

    # Git configuration
    git = {
      enable = true;
      enableDelta = true;
      enableLazygit = true;
      enableGitHub = true;
      # userName is set in host-specific home.nix
      # userEmail is set in host-specific home.nix
    };

    # Theme configuration
    starship.enable = false;

    # Oh My Posh prompt
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "pure";
    };

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
      enableCorepack = true; # Disabled to avoid build issues
    };

    nix.enableTools = true;

    cloud = {
      enable = true;
      aws.enable = true;
      terraform.enable = true;
      kubernetes.enable = true;
    };

    containers.enable = true;

    dotfiles = {
      enable = true;
      configs.starship = false;
    };

    # GPG configuration
    gpg = {
      enable = true;
    };

    fastfetch = {
      enable = true;
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
    stateVersion = "24.11";

    # Packages are managed through modules
    packages = [ ];
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 43200;
      pinentry = {
        package = pkgs.pinentry_mac;
      };
    };

  };

  xdg = {
    enable = true;
  };
}
