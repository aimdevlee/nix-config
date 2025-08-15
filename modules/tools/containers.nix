# Container tools configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.tools.containers;
in
{
  options.modules.tools.containers = {
    enable = lib.mkEnableOption "container development tools";
    
    runtime = lib.mkOption {
      type = lib.types.enum [ "podman" "docker" ];
      default = "podman";
      description = "Container runtime to use";
    };
    
    enableCompose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable docker/podman-compose";
    };
    
    enableBuildKit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable BuildKit for better container builds";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; 
      # Container runtime
      (if cfg.runtime == "podman" then
        [ podman ]
        ++ lib.optional cfg.enableCompose podman-compose
      else
        [ ]
        # Docker would be installed via Homebrew on macOS
      )
      # Additional container tools
      ++ lib.optional cfg.enableBuildKit buildkit;
    
    # Container-specific aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable (
      if cfg.runtime == "podman" then {
        # Podman aliases (Docker-compatible)
        docker = "podman";
        d = "podman";
        dps = "podman ps";
        dpsa = "podman ps -a";
        di = "podman images";
        drun = "podman run";
        dexec = "podman exec";
        dlogs = "podman logs";
        dstop = "podman stop";
        drm = "podman rm";
        drmi = "podman rmi";
        
        # Compose shortcuts
        dc = lib.mkIf cfg.enableCompose "podman-compose";
        dcu = lib.mkIf cfg.enableCompose "podman-compose up";
        dcd = lib.mkIf cfg.enableCompose "podman-compose down";
        dcl = lib.mkIf cfg.enableCompose "podman-compose logs";
      } else {
        # Docker aliases
        d = "docker";
        dps = "docker ps";
        dpsa = "docker ps -a";
        di = "docker images";
        drun = "docker run";
        dexec = "docker exec";
        dlogs = "docker logs";
        dstop = "docker stop";
        drm = "docker rm";
        drmi = "docker rmi";
        
        # Compose shortcuts
        dc = lib.mkIf cfg.enableCompose "docker compose";
        dcu = lib.mkIf cfg.enableCompose "docker compose up";
        dcd = lib.mkIf cfg.enableCompose "docker compose down";
        dcl = lib.mkIf cfg.enableCompose "docker compose logs";
      }
    );
    
    # Container environment variables
    home.sessionVariables = lib.mkIf cfg.enableBuildKit {
      DOCKER_BUILDKIT = "1";
    };
  };
}