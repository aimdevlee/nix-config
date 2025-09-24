# Tmux user configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userPrograms.tmux;
in
{
  options.userPrograms.tmux = {
    enable = lib.mkEnableOption "tmux terminal multiplexer with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    # Install tmux package directly (bypass home-manager's tmux module)
    home.packages = with pkgs; [
      tmux
      tmuxinator
    ];

    # Copy config file from source
    home.file.".config/tmux/tmux.conf" = {
      source = ./configs/tmux/tmux.conf;
    };
  };
}
