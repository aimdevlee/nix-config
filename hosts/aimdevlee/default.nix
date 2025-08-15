{ inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config.apple_sdk.frameworks.Security.provider = "pkg-config";
    config.apple_sdk.frameworks.SystemConfiguration.provider = "pkg-config";
    config.allowUnfree = true;
  };
in
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
    users.aimdevlee = {
      _module.args = { inherit unstable-pkgs; };
      imports = [ ./home-manager/home.nix ];
    };
  };

  # Set the platform for this configuration.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility.
  system.stateVersion = 6;
}
