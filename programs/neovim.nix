# Neovim user configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.neovim;
in
{
  options.userPrograms.neovim = {
    enable = lib.mkEnableOption "Neovim text editor with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Enable home-manager's neovim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Copy config from source
    home.file.".config/nvim" = lib.mkForce {
      source = ./configs/nvim;
      recursive = true;
    };
  };
}
