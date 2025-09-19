# Node.js development environment
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.nodejs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Node.js development environment";
    };

    version = lib.mkOption {
      type = lib.types.enum [
        "20"
        "22"
        "24"
      ];
      default = "24";
      description = "Node.js major version";
    };
    enableCorepack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable corepack";
    };
  };

  config = lib.mkIf config.programs.nodejs.enable {
    home.packages =
      with pkgs;
      let
        nodePackage = pkgs."nodejs_${config.programs.nodejs.version}";
        corepackPackage = pkgs."corepack_${config.programs.nodejs.version}";
      in
      [ nodePackage ] ++ lib.optionals config.programs.nodejs.enableCorepack [ corepackPackage ];

    home.sessionVariables = {
      # Reasonable default memory limit for Node.js
      NODE_OPTIONS = "--max-old-space-size=4096";
    };
  };
}
