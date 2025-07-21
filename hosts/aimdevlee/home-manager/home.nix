# User-specific configuration for "aimdevlee" managed by home-manager.
# Located at: hosts/Dongbin-MacBookPro/home-manager/home.nix
{ pkgs, ... }:
{
  # Define packages to be installed for the user.
  home.packages = with pkgs; [
    gh
    podman
    awscli
    nixfmt-rfc-style
    nil
    lua-language-server
    eza
  ];

  # Set environment variables for the user session.
  home.sessionVariables = {
    STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";
    EDITOR = "nvim";
  };

  # Link dotfiles to their correct locations in $HOME.
  # The dotfiles directory is expected to be in the same directory as this file.
  home.file = {
    ".config/starship/starship.toml".source = ./dotfiles/starship/starship.toml;
    ".config/nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };
    ".config/ghostty/config".source = ./dotfiles/ghostty/config;
    ".config/aerospace/aerospace.toml".source = ./dotfiles/aerospace/aerospace.toml;
    ".config/karabiner" = {
      source = ./dotfiles/karabiner;
      recursive = true;
    };
  };

  # Program-specific configurations
  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      initContent = ''
        # Initialize Homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
      shellAliases = {
        ls = "eza";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    neovim.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "aimdevlee";
      userEmail = "aimdevlee@gmail.com";
    };
  };

  # Set the state version for home-manager.
  home.stateVersion = "25.05";
}
