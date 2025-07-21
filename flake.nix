{
  description = "Dongbin's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    {
      # Build a darwin flake using:
      # $ darwin-rebuild switch --flake .#Dongbin-MacBookPro
      darwinConfigurations."aimdevlee" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        # Pass all inputs to the host-specific configuration
        specialArgs = { inherit inputs; };
        # The main entry point for this system's configuration
        modules = [ ./hosts/aimdevlee ];
      };
    };
}
