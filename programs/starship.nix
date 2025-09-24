# Starship user configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.starship;
in
{
  options.userPrograms.starship = {
    enable = lib.mkEnableOption "Starship prompt with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Enable home-manager's starship
    programs.starship.enable = true;

    # Override the config file with our custom config
    xdg.configFile."starship.toml" = lib.mkForce {
      source = ./configs/starship.toml;
    };
  };
}
