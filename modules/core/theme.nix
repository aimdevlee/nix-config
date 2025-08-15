# Centralized theme and appearance configuration
{ config, lib, pkgs, ... }:
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
    home.packages = lib.optionals (!constants.isDarwin) (with pkgs; [
      (nerdfonts.override { fonts = [ "UbuntuMono" "JetBrainsMono" ]; })
    ]);

    # Starship prompt theming
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        # Use theme colors for starship
        format = lib.concatStrings [
          "[](${config.modules.theme.colors.surface0})"
          "$os"
          "$username"
          "[](bg:${config.modules.theme.colors.surface1} fg:${config.modules.theme.colors.surface0})"
          "$directory"
          "[](fg:${config.modules.theme.colors.surface1} bg:${config.modules.theme.colors.surface2})"
          "$git_branch"
          "$git_status"
          "[](fg:${config.modules.theme.colors.surface2} bg:${config.modules.theme.colors.mantle})"
          "$c"
          "$elixir"
          "$elm"
          "$golang"
          "$haskell"
          "$java"
          "$julia"
          "$nodejs"
          "$nim"
          "$rust"
          "$scala"
          "[](fg:${config.modules.theme.colors.mantle})"
          "\n$character"
        ];

        # Character module with theme colors
        character = {
          success_symbol = "[➜](bold ${config.modules.theme.colors.green})";
          error_symbol = "[➜](bold ${config.modules.theme.colors.red})";
        };

        # Directory module with theme colors
        directory = {
          style = "fg:${config.modules.theme.colors.lavender} bg:${config.modules.theme.colors.surface1}";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        # Git branch with theme colors
        git_branch = {
          symbol = "";
          style = "bg:${config.modules.theme.colors.surface2}";
          format = "[[ $symbol $branch ](fg:${config.modules.theme.colors.green} bg:${config.modules.theme.colors.surface2})]($style)";
        };

        # Git status with theme colors
        git_status = {
          style = "bg:${config.modules.theme.colors.surface2}";
          format = "[[($all_status$ahead_behind )](fg:${config.modules.theme.colors.green} bg:${config.modules.theme.colors.surface2})]($style)";
        };
      };
    };
  };
}