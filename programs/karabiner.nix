# Karabiner-Elements keyboard customization configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.karabiner;
in
{
  options.userPrograms.karabiner = {
    enable = lib.mkEnableOption "Karabiner-Elements keyboard customization with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Karabiner is installed via Homebrew, just manage config
    home.file.".config/karabiner" = {
      source = ./configs/karabiner;
      recursive = true;
    };
  };
}
