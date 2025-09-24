# Aerospace window manager configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.aerospace;
in
{
  options.userPrograms.aerospace = {
    enable = lib.mkEnableOption "Aerospace window manager with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Aerospace is installed via Homebrew, just manage config
    home.file.".config/aerospace" = {
      source = ./configs/aerospace;
      recursive = true;
    };
  };
}
