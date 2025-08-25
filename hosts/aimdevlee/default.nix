# Host-specific configuration for aimdevlee
{
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common/system.nix # Common system configuration
    ./system.nix # Host-specific system overrides
  ];

  # Host identification
  networking.hostName = "aimdevlee";

  # User configuration
  users.users.aimdevlee = {
    name = "aimdevlee";
    home = "/Users/aimdevlee";
  };

  # Home-manager configuration
  home-manager = {
    users.aimdevlee = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Host platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
