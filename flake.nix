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
      }
    );
}
