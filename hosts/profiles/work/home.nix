# Work profile home-manager configuration
{ lib, pkgs, ... }:
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
        ccusage = "npx ccusage@latest";
      };

      # Custom init for work profile configurations
      initContent = ''
        # FZF configuration
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

    # Enable fzf
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Git user configuration is in ~/.gitconfig.local
    # git = {
    #   userName and userEmail are set in ~/.gitconfig.local
    # };

    dotfiles = {
      configs = {
        nvim = lib.mkForce false;
      };
    };
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
