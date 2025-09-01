# Main overlay configuration
# Manages package versions and custom modifications
{ inputs }:
let
  # Import unstable packages overlay
  unstablePackages = import ./unstable-packages.nix { inherit inputs; };
in
# Combine all overlays
[
  # Unstable packages overlay
  unstablePackages

  # Custom package modifications
  (_final: prev: {
    # Disable tests for Node.js packages to avoid sandbox network test failures
    nodejs_20 = prev.nodejs_20.overrideAttrs (_oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    });

    nodejs_22 = prev.nodejs_22.overrideAttrs (_oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    });

    nodejs_24 = prev.nodejs_24.overrideAttrs (_oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    });
  })
]
