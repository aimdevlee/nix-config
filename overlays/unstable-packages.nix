# Unstable packages overlay
# Dynamically selects packages from nixpkgs-unstable based on configuration
{ inputs }:
final: _prev:
let
  # Import unstable nixpkgs
  unstable = import inputs.nixpkgs-unstable {
    inherit (final) system;
    config.allowUnfree = true;
  };

  # Import overlay configuration
  overlayConfig = import ./config.nix;

  # Helper function to get unstable packages from a list
  getUnstablePackages =
    pkgList:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = unstable.${name};
      }) pkgList
    );

  # Combine all unstable packages
  unstablePackages =
    # Development tools
    getUnstablePackages overlayConfig.development
    # Terminal tools
    // getUnstablePackages overlayConfig.terminal
    # Cloud tools
    // getUnstablePackages overlayConfig.cloud
    # Container tools
    // getUnstablePackages overlayConfig.containers
    # Node.js special handling
    // {
      nodejs = unstable.${overlayConfig.nodejs.version};
    };
in
unstablePackages
// {
  # Add unstable package set as an attribute for optional use
  unstable-pkgs = unstable;
}
