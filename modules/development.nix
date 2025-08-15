# Development tools and environment configuration
{ config, lib, pkgs, unstable-pkgs ? pkgs, ... }:
let
  constants = import ../lib/default.nix { inherit lib pkgs; };
in
{
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
      description = "Enable cloud development tools (AWS, etc.)";
    };
    
    enableContainers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable container tools (Docker/Podman)";
    };
  };

  config = lib.mkIf config.modules.development.enable {
    home.packages = with pkgs; 
      # Core development tools
      [
        # Version control
        gh  # GitHub CLI
        
        # Terminal tools
        tmux
        eza  # Better ls
      ]
      
      # Node.js development
      ++ lib.optionals config.modules.development.enableNodejs [
        nodejs_24
        # Add yarn, pnpm if needed
      ]
      
      # Nix development
      ++ lib.optionals config.modules.development.enableNix [
        nixfmt-rfc-style  # Nix formatter
        nil  # Nix LSP
      ]
      
      # LSP servers
      ++ lib.optionals config.modules.development.enableLsp [
        lua-language-server
        # Add more LSP servers as needed
      ]
      
      # Cloud tools
      ++ lib.optionals config.modules.development.enableCloud [
        awscli
        # Add terraform, kubectl, etc. if needed
      ]
      
      # Container tools
      ++ lib.optionals config.modules.development.enableContainers [
        podman
        # Add docker-compose, k9s, etc. if needed
      ];

    # Shell aliases for development
    programs.zsh.shellAliases = {
      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gco = "git checkout";
      gb = "git branch";
      
      # Directory navigation
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      
      # Nix shortcuts
      ns = "sudo darwin-rebuild switch";
      nfu = "nix flake update";
      nfc = "nix flake check";
      
      # Development shortcuts
      v = "nvim";
      t = "tmux";
      ta = "tmux attach";
      tn = "tmux new-session -s";
    };

    # Zoxide for smart directory jumping
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Development-related environment variables
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      LESS = "-R";
    };
  };
}