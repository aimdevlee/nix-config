# Centralized theme and appearance configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  constants = import ../../lib/default.nix { inherit lib pkgs; };
in
{
  options.modules.theme = {
    enable = lib.mkEnableOption "theme configuration module";

    name = lib.mkOption {
      type = lib.types.str;
      default = constants.theme.name;
      description = "Theme name";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      default = constants.theme.colors;
      description = "Color palette for the theme";
    };

    fonts = lib.mkOption {
      type = lib.types.attrs;
      default = constants.fonts;
      description = "Font configuration";
    };
  };

  config = lib.mkIf config.modules.theme.enable {
    # Make theme available to other modules
    home.sessionVariables = {
      THEME_NAME = config.modules.theme.name;
    };

    # Font packages (if on Darwin, these are handled by Homebrew)
    home.packages = lib.optionals (!constants.isDarwin) (
      with pkgs;
      [
        (nerdfonts.override {
          fonts = [
            "UbuntuMono"
            "JetBrainsMono"
          ];
        })
      ]
    );

    # Starship prompt theming
    # Note: Using external config file instead of Nix settings
    # Config is managed via home.file in home.nix
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Settings are loaded from ~/.config/starship/starship.toml
      # We don't define settings here to avoid conflicts
      settings = { }; # Empty to use external config file
    };
  };
}
