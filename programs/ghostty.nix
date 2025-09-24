# Ghostty terminal configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.ghostty;
in
{
  options.userPrograms.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal emulator with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Ghostty is installed via Homebrew, just manage config
    home.file.".config/ghostty" = {
      source = ./configs/ghostty;
      recursive = true;
    };
  };
}
