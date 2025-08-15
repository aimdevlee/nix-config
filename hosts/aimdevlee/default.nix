{ inputs, ... }:
let
  # Import overlay configuration
  overlays = import ../../overlays/default.nix { inherit inputs; };
in
{
  # Import the system-wide configuration and the home-manager module.
  imports = [
    ./configuration.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  # Apply overlays for package management
  nixpkgs.overlays = overlays;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define the user for this system.
  users.users.aimdevlee = {
    name = "aimdevlee";
    home = "/Users/aimdevlee";
  };

  # Configure home-manager to manage the user "aimdevlee".
  # It imports the configuration from the dedicated home.nix file.
  home-manager = {
    users.aimdevlee = {
      imports = [ ./home-manager/home.nix ];
    };

    # Use system packages (with overlays applied)
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Set the platform for this configuration.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility.
  system.stateVersion = 6;
}
