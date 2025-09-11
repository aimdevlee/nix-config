# Personal profile configuration
{
  inputs,
  ...
}:
{
  imports = [
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
    extraSpecialArgs = { inherit inputs; };
  };

  # System platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
