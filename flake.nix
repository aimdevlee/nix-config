{
  description = "Dongbin's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Provides utilities for working with multiple systems
    flake-utils.url = "github:numtide/flake-utils";

    # Pre-commit hooks for code quality enforcement
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      flake-utils,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      # Function to create a Darwin system configuration for a profile
      mkDarwinSystem =
        profile:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            system = "aarch64-darwin"; # Explicitly define system
          };
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ./hosts/common/system.nix
            ./hosts/profiles/${profile}/default.nix
          ];
        };
    in
    # System-specific outputs (Darwin configurations)
    {
      # Define profile-based configurations (no real host names)
      darwinConfigurations = {
        personal = mkDarwinSystem "personal";
        work = mkDarwinSystem "work";
        # Add more profiles here as needed
        # dev = mkDarwinSystem "dev";
      };
    }
    # Cross-platform outputs using flake-utils
    // flake-utils.lib.eachDefaultSystem (
      system:
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
            nixfmt-rfc-style # Format .nix files
            nil # Nix LSP for editor support

            # Flake management
            nix-tree # Visualize nix dependencies
            nix-output-monitor # Better nix build output

            # Code quality tools
            deadnix # Find unused nix code
            statix # Nix anti-pattern linter

            # Git helpers
            git
            gh # GitHub CLI
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

        # Pre-commit hooks for maintaining code quality
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              # Nix formatting check (RFC 166 style)
              nixfmt-rfc-style.enable = true;

              # Find dead Nix code
              deadnix.enable = true;

              # Nix anti-pattern detection
              statix.enable = true;
            };
          };
        };
      }
    );
}
