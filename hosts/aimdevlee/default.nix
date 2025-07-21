# This is the main entry point for the "Dongbin-MacBookPro" host.
{ inputs, ... }:
{
  # Import the system-wide configuration and the home-manager module.
  imports = [
    ./configuration.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  # Define the user for this system.
  users.users.aimdevlee = {
    name = "aimdevlee";
    home = "/Users/aimdevlee";
  };

  # Configure home-manager to manage the user "aimdevlee".
  # It imports the configuration from the dedicated home.nix file.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aimdevlee = import ./home-manager/home.nix;
  };

  # Set the platform for this configuration.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility.
  system.stateVersion = 6;
}
