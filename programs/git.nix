# Git configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.git = {
    # Git configuration options are provided by home-manager
    # Additional custom options can be added here
    enableDelta = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable delta for better git diffs";
    };
  };

  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      # Delta configuration for better diffs
      delta = lib.mkIf config.programs.git.enableDelta {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
        };
      };

      # Git aliases
      aliases = {
        # Add your git aliases here
        # st = "status";
        # co = "checkout";
        # br = "branch";
      };

      # Extra git configuration
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        push.autoSetupRemote = true;
      };
    };

    # Git-related packages
    home.packages = with pkgs; [
      # gh is added separately if needed
      # delta is handled by programs.git.delta
    ];
  };
}
