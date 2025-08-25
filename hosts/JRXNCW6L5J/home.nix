# Host-specific home-manager configuration for JRXNCW6L5J
{ ... }:
{
  imports = [
    ../common/home.nix # Import common home configuration
  ];

  # Host-specific program configurations
  programs.git.userName = "dongbin-lee";
  programs.git.userEmail = "aimdevlee@gmail.com";

  # Host-specific package additions
  # home.packages = with pkgs; [
  #   # Add host-specific packages here
  # ];

  # Host-specific module overrides
  # Example: Different configuration for this work machine
  # programs.containers.runtime = "docker";  # Use Docker instead of Podman
}
