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

  # Custom package modifications (placeholder for future use)
  (_final: _prev: {
    # Example: Override a package with custom configuration
    # neovim = prev.neovim.override {
    #   withNodeJs = true;
    #   withPython3 = true;
    # };

    # Example: Add a custom package
    # myCustomPackage = final.callPackage ./packages/my-package.nix { };
  })
]
