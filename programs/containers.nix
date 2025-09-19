# Container runtime configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.containers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable container runtime tools";
    };

    runtime = lib.mkOption {
      type = lib.types.enum [
        "docker"
        "colima"
      ];
      default = "colima";
      description = "Container runtime to use";
    };
  };

  config = lib.mkIf config.programs.containers.enable {
    home.packages =
      with pkgs;
      [
        docker
        docker-credential-helpers
        docker-compose
      ]
      ++ lib.optional (config.programs.containers.runtime == "colima") colima;

    # Environment variables
    home.sessionVariables = lib.mkIf (config.programs.containers.runtime == "colima") {
      # DOCKER_HOST = "unix://\$HOME/.colima/docker.sock";
    };
  };
}
