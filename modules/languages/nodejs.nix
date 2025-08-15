# Node.js development environment configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.languages.nodejs;
in
{
  options.modules.languages.nodejs = {
    enable = lib.mkEnableOption "Node.js development environment";

    version = lib.mkOption {
      type = lib.types.enum [
        "20"
        "22"
        "24"
      ];
      default = "24";
      description = "Node.js major version to use";
    };

    packageManager = lib.mkOption {
      type = lib.types.enum [
        "npm"
        "yarn"
        "pnpm"
        "none"
      ];
      default = "npm";
      description = "Additional package manager to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      # Base Node.js package based on selected version
      let
        nodePackage =
          if cfg.version == "20" then
            nodejs_20
          else if cfg.version == "22" then
            nodejs_22
          else
            nodejs_24;
      in
      [ nodePackage ]
      # Add selected package manager
      ++ lib.optional (cfg.packageManager == "yarn") yarn
      ++ lib.optional (cfg.packageManager == "pnpm") pnpm;

    # Node.js specific environment variables
    home.sessionVariables = {
      # Increase Node memory limit for large projects
      NODE_OPTIONS = "--max-old-space-size=4096";
    };

    # Node.js specific aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      # npm shortcuts
      ni = "npm install";
      nr = "npm run";
      nt = "npm test";

      # Common scripts
      dev = "npm run dev";
      build = "npm run build";
      start = "npm start";
    };
  };
}
