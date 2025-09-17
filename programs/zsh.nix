# Zsh shell configuration
{
  config,
  lib,
  ...
}:
{
  options.programs.zsh = {
    # Additional zsh-specific options can be added here
    enableAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable custom shell aliases";
    };
  };

  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh = {
      shellAliases = lib.mkIf config.programs.zsh.enableAliases {
        # Common aliases
        # Add your custom aliases here
        # v = "nvim";
        g = "git";
        # ls = "eza --color=always --group-directories-first --icons";
        # ll = "eza -la --icons --octal-permissions --group-directories-first";
      };

      initContent = ''
        # Additional zsh configuration
        # Add custom zsh configurations here
      '';
    };

    # Enable zoxide - a smarter cd command
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Environment variables for shell
    home.sessionVariables = {
      # Shell-specific environment variables
    };
  };
}
