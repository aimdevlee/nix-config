# Unstable packages overlay
# Selects packages from nixpkgs-unstable based on configuration
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

  # Create unstable package overrides
  unstablePackages = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = unstable.${name};
    }) overlayConfig.packages
  );
in
unstablePackages
// {
  # Add unstable package set as an attribute for optional use
  unstable-pkgs = unstable;
}
