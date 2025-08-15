# Shell environment variables configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.shell.environment;
  constants = import ../../lib/default.nix { inherit lib pkgs; };
in
{
  options.modules.shell.environment = {
    enable = lib.mkEnableOption "shell environment variables";
    
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Default text editor";
    };
    
    pager = lib.mkOption {
      type = lib.types.str;
      default = "less";
      description = "Default pager for viewing text";
    };
  };

  config = lib.mkIf cfg.enable {
    # Core environment variables
    home.sessionVariables = {
      EDITOR = cfg.editor;
      VISUAL = cfg.editor;
      PAGER = cfg.pager;
      LESS = "-R";
      
      # XDG Base Directory Specification
      XDG_CONFIG_HOME = "${constants.user.homeDirectory}/.config";
      XDG_DATA_HOME = "${constants.user.homeDirectory}/.local/share";
      XDG_CACHE_HOME = "${constants.user.homeDirectory}/.cache";
      XDG_STATE_HOME = "${constants.user.homeDirectory}/.local/state";
      
      # Development environment
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      
      # Tool-specific configurations
      STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";
    };
    
    # Zoxide for smart directory jumping
    programs.zoxide = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}