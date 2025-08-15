# Shared constants and utilities for the nix-darwin configuration
{ lib, pkgs, ... }:
let
  # Detect if we're on Darwin/macOS
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # System-specific configurations
  systemConfig =
    if isDarwin then
      {
        architecture = "aarch64-darwin";
        stateVersion = 6;
      }
    else
      {
        architecture = "x86_64-linux"; # or detect actual Linux arch
        stateVersion = "24.05"; # NixOS version
      };
in
{
  inherit isDarwin isLinux;

  # User configuration constants
  user = {
    name = "aimdevlee";
    email = "aimdevlee@gmail.com";
    homeDirectory = if isDarwin then "/Users/aimdevlee" else "/home/aimdevlee";
  };

  # System configuration constants
  system = systemConfig // {
    homeManagerStateVersion = "25.05";
  };

  # Common paths
  paths = {
    configHome = "$HOME/.config";
  };

  # Font configurations used across multiple applications
  fonts = {
    primary = "UDev Gothic NF";
    japanese = "PlemolJP Console NF";
    korean = "NanumGothicCoding";
    terminal = "UDev Gothic NF";
  };

  # Catppuccin Mocha color palette
  # Used consistently across all themed applications
  theme = {
    name = "catppuccin-mocha";
    colors = {
      # Base colors
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";

      # Surface colors
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";

      # Background colors
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };
  };
}
