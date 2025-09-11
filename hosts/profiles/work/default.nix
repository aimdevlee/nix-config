# Work profile configuration
{
  inputs,
  ...
}:
{
  imports = [
    ./system.nix # Profile-specific system overrides
  ];

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
    extraSpecialArgs = { inherit inputs; };
  };

  # System platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
