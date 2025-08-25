# Host-specific configuration for JRXNCW6L5J
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
  networking.hostName = "JRXNCW6L5J";

  # User configuration
  users.users.dongbin-lee = {
    name = "dongbin-lee";
    home = "/Users/dongbin-lee";
  };

  # Home-manager configuration
  home-manager = {
    users.dongbin-lee = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Host platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
