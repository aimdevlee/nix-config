# Git configuration and tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.tools.git;
in
{
  options.modules.tools.git = {
    enable = lib.mkEnableOption "Git tools and configuration";

    enableGitHub = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GitHub CLI and related tools";
    };

    enableDelta = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable delta for better git diffs";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      # GitHub CLI for PR management
      ++ lib.optional cfg.enableGitHub gh
      # Enhanced diff viewer
      ++ lib.optional cfg.enableDelta delta;

    # Git aliases for common operations
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      # Basic git commands
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gco = "git checkout";
      gb = "git branch";

      # Advanced git commands
      glog = "git log --oneline --graph --decorate";
      gdiff = "git diff";
      gstash = "git stash";
      grebase = "git rebase";
      gmerge = "git merge";

      # Git flow shortcuts
      gf = "git flow";
      gfi = "git flow init";
      gff = "git flow feature";
      gfr = "git flow release";
      gfh = "git flow hotfix";
    };

    # Delta configuration for better diffs
    programs.git.delta = lib.mkIf cfg.enableDelta {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
}
