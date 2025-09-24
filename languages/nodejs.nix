# Node.js development environment
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.nodejs;
in
{
  options.languages.nodejs = {
    enable = lib.mkEnableOption "Node.js development environment";

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
      description = "Enable corepack for package manager management";
    };

    globalPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "typescript"
        "prettier"
        "eslint"
      ];
      description = "Node packages to install globally";
    };

    memoryLimit = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 4096;
      example = 8192;
      description = "Maximum memory in MB for Node.js heap (null to disable)";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        let
          nodePackage = pkgs."nodejs_${cfg.version}";
          corepackPackage = pkgs."corepack_${cfg.version}";
          nodeWithPackages =
            if cfg.globalPackages != [ ] then
              nodePackage.pkgs.buildNodePackage {
                name = "nodejs-with-packages";
                packageName = "nodejs-with-packages";
                version = "1.0.0";
                src = pkgs.writeTextDir "package.json" (
                  builtins.toJSON {
                    name = "nodejs-with-packages";
                    version = "1.0.0";
                  }
                );
                deps = map (pkg: nodePackage.pkgs.${pkg}) cfg.globalPackages;
              }
            else
              nodePackage;
        in
        [ nodeWithPackages ] ++ lib.optional cfg.enableCorepack corepackPackage;

      sessionVariables = lib.mkIf (cfg.memoryLimit != null) {
        NODE_OPTIONS = "--max-old-space-size=${toString cfg.memoryLimit}";
        PNPM_HOME = "${config.xdg.dataHome}/pnpm";
      };

      sessionPath = [
        "$PNPM_HOME"
      ];
    };
  };
}
