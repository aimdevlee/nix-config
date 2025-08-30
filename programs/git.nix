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
    enableLazygit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Lazygit";
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
        pull.rebase = true;
        push = {
          autoSetupRemote = true;
          default = "simple";
        };

        # Core settings
        core = {
          editor = "nvim";
          excludesfile = "~/.gitignore";
        };

        # Merge and diff tools
        merge.tool = "nvimdiff";
        mergetool.keepBackup = false;
        difftool.prompt = false;

        # Colors
        color = {
          diff = "auto";
          status = "auto";
          branch = "auto";
          ui = true;
        };

        # Help
        help.autocorrect = 1;

        # Include local config for user-specific settings
        include.path = "~/.gitconfig.local";
      };
    };

    programs.lazygit = lib.mkIf config.programs.git.enableLazygit {
      enable = true;
      settings = {
        git.overrideGpg = true;
      };
    };

    # Git-related packages
    home.packages =
      with pkgs;
      [
        # GitHub CLI
        gh

        # Git UI and helpers

        # Security
        gitleaks # Detect secrets in git repos
      ]
      # Delta is conditionally added based on enableDelta option
      ++ lib.optionals config.programs.git.enableDelta [ delta ];
  };
}
