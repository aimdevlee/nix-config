# Host-specific home-manager configuration for aimdevlee
{ ... }:
{
  imports = [
    ../common/home.nix # Import common home configuration
  ];

  # Host-specific program configurations
  programs.git.userName = "aimdevlee";
  programs.git.userEmail = "aimdevlee@gmail.com";

  # Host-specific package additions
  # home.packages = with pkgs; [
  #   # Add host-specific packages here
  # ];

  # Host-specific module overrides
  # Example: adjust nodejs version for this host
  # programs.nodejs.version = "24";
}
