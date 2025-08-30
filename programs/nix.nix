# Nix development tools
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.nix = {
    enableTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix development tools";
    };
  };

  config = lib.mkIf config.programs.nix.enableTools {
    home.packages = with pkgs; [
      # Nix development essentials
      nixfmt-rfc-style # Format .nix files
      deadnix # Find unused nix code
      statix # Nix anti-pattern linter
      nix-tree # Visualize nix dependencies
      nix-output-monitor # Better nix build output
    ];
  };
}
