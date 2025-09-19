# Core shell utilities and tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.shellEssentials;
in
{
  options.programs.shellEssentials = {
    enable = lib.mkEnableOption "core shell utilities and productivity tools";

    search = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable search and find utilities";
      };
    };

    fileViewers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable enhanced file viewers and processors";
      };
    };

    network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable network and download tools";
      };
    };

    security = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable security tools";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals cfg.search.enable [
        ripgrep # Fast text search
        fd # Fast file finder
        fzf # Fuzzy finder
      ]
      ++ lib.optionals cfg.fileViewers.enable [
        bat # Better cat with syntax highlighting
        eza # Modern ls replacement
        tree # Directory tree viewer
        jq # JSON processor
        yq # YAML processor
      ]
      ++ lib.optionals cfg.network.enable [
        wget # File downloader
        curl # Data transfer tool
        htop # Interactive process viewer
      ]
      ++ lib.optionals cfg.security.enable [
        sops # Secrets management
      ];
  };
}
