# Core shell utilities and tools
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.shellEssentials = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable core shell utilities and productivity tools";
    };
  };

  config = lib.mkIf config.programs.shellEssentials.enable {
    home.packages = with pkgs; [
      # Search and find utilities
      ripgrep # Fast text search
      fd # Fast file finder
      fzf # Fuzzy finder

      # File viewers and processors
      bat # Better cat with syntax highlighting
      eza # Modern ls replacement
      tree # Directory tree viewer
      jq # JSON processor
      yq # YAML processor

      # Network and system tools
      wget # File downloader
      curl # Data transfer tool
      htop # Interactive process viewer

      # Security tools
      sops # Secrets management
    ];
  };
}
