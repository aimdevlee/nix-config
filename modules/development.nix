# Development module aggregator - imports and configures all development modules
{ config, lib, pkgs, unstable-pkgs ? pkgs, ... }:
{
  imports = [
    # Language-specific modules
    ./languages/nodejs.nix
    
    # Development tools
    ./tools/git.nix
    ./tools/cloud.nix
    ./tools/containers.nix
    ./tools/nix.nix
    
    # Shell configuration
    ./shell/aliases.nix
    ./shell/environment.nix
  ];
  
  # Backward compatibility options for existing configuration
  options.modules.development = {
    enable = lib.mkEnableOption "development tools module";
    
    enableNodejs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Node.js development tools";
    };
    
    enableNix = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix development tools";
    };
    
    enableLsp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable LSP servers";
    };
    
    enableCloud = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable cloud development tools";
    };
    
    enableContainers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable container tools";
    };
  };
  
  # Map old options to new modular structure for backward compatibility
  config = lib.mkIf config.modules.development.enable {
    # Enable new modular structure based on old options
    modules.languages.nodejs = {
      enable = config.modules.development.enableNodejs;
      version = "24";
      packageManager = "npm";
    };
    
    modules.tools = {
      git = {
        enable = true;
        enableGitHub = true;
      };
      
      nix = {
        enable = config.modules.development.enableNix;
        enableLSP = config.modules.development.enableLsp;
      };
      
      cloud = {
        enable = config.modules.development.enableCloud;
        enableAWS = true;
      };
      
      containers = {
        enable = config.modules.development.enableContainers;
        runtime = "podman";
      };
    };
    
    modules.shell = {
      aliases.enable = true;
      environment.enable = true;
    };
    
    # Additional packages that don't fit into specific modules
    home.packages = with pkgs; [
      # Terminal tools
      tmux
      
      # Language servers (if enableLsp is true)
    ] ++ lib.optional config.modules.development.enableLsp
      pkgs.lua-language-server;
  };
}