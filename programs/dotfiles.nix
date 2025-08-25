# Dotfiles management
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Base path for config files
  configPath = ../dotfiles;
in
{
  options.programs.dotfiles = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable dotfiles management";
    };

    configs = {
      starship = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Starship prompt configuration";
      };

      nvim = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Neovim configuration";
      };

      ghostty = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Ghostty terminal configuration";
      };

      aerospace = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Aerospace window manager configuration";
      };

      karabiner = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Karabiner keyboard customization";
      };

      tmux = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable tmux configuration";
      };
    };
  };

  config = lib.mkIf config.programs.dotfiles.enable {
    home.file = lib.mkMerge [
      # Starship configuration
      (lib.mkIf config.programs.dotfiles.configs.starship {
        ".config/starship/starship.toml".source = "${configPath}/starship.toml";
      })

      # Neovim configuration
      (lib.mkIf config.programs.dotfiles.configs.nvim {
        ".config/nvim" = {
          source = "${configPath}/nvim";
          recursive = true;
        };
      })

      # Ghostty configuration
      (lib.mkIf config.programs.dotfiles.configs.ghostty {
        ".config/ghostty" = {
          source = "${configPath}/ghostty";
          recursive = true;
        };
      })

      # Aerospace configuration
      (lib.mkIf config.programs.dotfiles.configs.aerospace {
        ".config/aerospace" = {
          source = "${configPath}/aerospace";
          recursive = true;
        };
      })

      # Karabiner configuration
      (lib.mkIf config.programs.dotfiles.configs.karabiner {
        ".config/karabiner" = {
          source = "${configPath}/karabiner";
          recursive = true;
        };
      })

      # Tmux configuration
      (lib.mkIf config.programs.dotfiles.configs.tmux {
        ".config/tmux/tmux.conf".source = "${configPath}/tmux/tmux.conf";
      })
    ];

    # Install required packages
    home.packages =
      with pkgs;
      lib.mkMerge [
        (lib.optionals config.programs.dotfiles.configs.nvim [ neovim ])
        (lib.optionals config.programs.dotfiles.configs.tmux [ tmux ])
      ];
  };
}
