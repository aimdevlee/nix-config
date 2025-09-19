# Work profile home-manager configuration
{ pkgs, ... }:
{
  imports = [
    ../../common/home.nix # Import common home configuration
  ];

  # Work profile program configurations
  programs = {
    zsh = {
      # Additional zsh configuration for work profile
      shellAliases = {
        ls = "eza";
      };

      # Custom init for work profile configurations
      initContent = '''';
    };

    # Enable fzf
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Git user configuration is in ~/.gitconfig.local
    # git = {
    #   userName and userEmail are set in ~/.gitconfig.local
    # };

    containers.enable = true;
  };

  # Work profile package additions
  home.packages = with pkgs; [
    # Add watchman only for work profile
    watchman
    # Add neovim even though dotfiles are disabled
    neovim
  ];

  # Work profile module overrides
  # Example: Different configuration for this work machine
  # programs.containers.runtime = "docker";  # Use Docker instead of Podman
}
