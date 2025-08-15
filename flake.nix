{
  description = "Dongbin's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Provides utilities for working with multiple systems
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    # System-specific outputs (Darwin configurations)
    {
      darwinConfigurations."aimdevlee" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/aimdevlee ];
      };
    }
    # Cross-platform outputs using flake-utils
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Code formatter for .nix files - enforces consistent style
        formatter = pkgs.nixfmt-rfc-style;
        
        # Development shell with useful tools for working on this configuration
        devShells.default = pkgs.mkShell {
          name = "nix-darwin-dev";
          
          buildInputs = with pkgs; [
            # Nix development essentials
            nixfmt-rfc-style  # Format .nix files
            nil               # Nix LSP for editor support
            
            # Flake management
            nix-tree          # Visualize nix dependencies
            nix-output-monitor # Better nix build output
            
            # Code quality tools
            deadnix           # Find unused nix code
            statix            # Nix anti-pattern linter
            
            # Git helpers
            git
            gh                # GitHub CLI
          ];
          
          shellHook = ''
            echo "🛠️  Nix-Darwin Development Environment"
            echo ""
            echo "Available commands:"
            echo "  nix fmt          - Format all .nix files"
            echo "  nix flake check  - Validate flake configuration"
            echo "  nix flake update - Update all flake inputs"
            echo "  darwin-rebuild   - Rebuild system configuration"
            echo ""
          '';
        };
      }
    );
}
