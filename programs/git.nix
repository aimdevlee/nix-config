# Git configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.git;
in
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
      description = "Enable Lazygit terminal UI";
    };

    enableGitHub = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GitHub CLI";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      # Delta configuration for better diffs
      delta = lib.mkIf cfg.enableDelta {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
        };
      };

      # Git aliases
      aliases = { };

      # Extra git configuration
      extraConfig = {
        init.defaultBranch = "main";

        pull = {
          rebase = true;
          ff = "only";
        };

        push = {
          autoSetupRemote = true;
          default = "simple";
        };

        # Core settings
        core = {
          editor = "nvim";
          excludesfile = "~/.gitignore";
          autocrlf = "input";
        };

        # Merge and diff tools
        merge = {
          tool = "nvimdiff";
          conflictstyle = "diff3";
        };

        mergetool = {
          keepBackup = false;
          prompt = false;
        };

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

        # Performance
        feature.manyFiles = true;

        # Include local config for user-specific settings
        include.path = "~/.gitconfig.local";
      };
    };

    programs.lazygit = lib.mkIf cfg.enableLazygit {
      enable = true;
      settings = {
        git = {
          overrideGpg = true;
          paging = {
            colorArg = "always";
            pager = "delta --paging=never";
          };
        };
        os.editPreset = "nvim";
      };
    };

    # Git-related packages
    home.packages = with pkgs; lib.optional cfg.enableGitHub gh;
  };
}
