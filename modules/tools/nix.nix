# Nix development tools configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.tools.nix;
in
{
  options.modules.tools.nix = {
    enable = lib.mkEnableOption "Nix development tools";
    
    enableLSP = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix language server";
    };
    
    enableFormatter = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix code formatter";
    };
    
    enableLinters = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix linters (deadnix, statix)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; 
      [ ]
      # Nix language server for editor support
      ++ lib.optional cfg.enableLSP nil
      # Code formatter
      ++ lib.optional cfg.enableFormatter nixfmt-rfc-style
      # Linting tools
      ++ lib.optionals cfg.enableLinters [
        deadnix  # Find dead code
        statix   # Anti-pattern checker
      ]
      # Additional useful tools
      ++ [
        nix-tree          # Visualize dependencies
        nix-output-monitor # Better build output
        # nix-index for command-not-found
      ];
    
    # Nix-specific aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      # Flake management
      nf = "nix flake";
      nfu = "nix flake update";
      nfc = "nix flake check";
      nfs = "nix flake show";
      nfmt = "nix fmt";
      
      # Build shortcuts
      nb = "nix build";
      ndev = "nix develop";
      nrun = "nix run";
      nshell = "nix shell";
      
      # System shortcuts (Darwin specific)
      ns = "sudo darwin-rebuild switch";
      nbs = "darwin-rebuild build && sudo darwin-rebuild switch";
      
      # Garbage collection
      ngc = "nix-collect-garbage";
      ngcd = "nix-collect-garbage -d";
    };
  };
}