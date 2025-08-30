# Personal profile configuration
{
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../common/system.nix # Common system configuration
    ./system.nix # Profile-specific system overrides
  ];

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

  # System platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
