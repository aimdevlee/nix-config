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
  };

  config = lib.mkIf config.programs.containers.enable {
    home.packages =
      with pkgs;

      # Docker packages
      [
        docker
        docker-credential-helpers
        docker-compose
        colima
      ];

    # Container-specific aliases
    programs.zsh.shellAliases = {
      # Common aliases that work for both
      # d = config.programs.containers.runtime;
      # dps = "${config.programs.containers.runtime} ps";
      # di = "${config.programs.containers.runtime} images";
    };

    # Environment variables
    home.sessionVariables = {
      # DOCKER_HOST = "unix://$HOME/.colima/docker.sock";
    };
  };
}
