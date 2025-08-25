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
        "podman"
      ];
      default = "podman";
      description = "Container runtime to use";
    };

    enableCompose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker/Podman Compose";
    };
  };

  config = lib.mkIf config.programs.containers.enable {
    home.packages =
      with pkgs;
      let
        isDocker = config.programs.containers.runtime == "docker";
        isPodman = config.programs.containers.runtime == "podman";
      in
      # Docker packages
      lib.optionals isDocker [
        docker
        docker-credential-helpers
      ]
      # Podman packages
      ++ lib.optionals isPodman [
        podman
        podman-compose
      ]
      # Compose (for Docker)
      ++ lib.optionals (isDocker && config.programs.containers.enableCompose) [
        docker-compose
      ];

    # Container-specific aliases
    programs.zsh.shellAliases = {
      # Common aliases that work for both
      # d = config.programs.containers.runtime;
      # dps = "${config.programs.containers.runtime} ps";
      # di = "${config.programs.containers.runtime} images";
    };

    # Environment variables
    home.sessionVariables = lib.mkIf (config.programs.containers.runtime == "docker") {
      DOCKER_HOST = "unix://$HOME/.colima/docker.sock";
    };
  };
}
