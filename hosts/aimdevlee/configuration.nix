# System-wide configuration for macOS using nix-darwin
{ pkgs, lib, ... }:
let
  constants = import ../../lib/default.nix { inherit lib pkgs; };
in
{
  # List packages installed in system profile
  environment.systemPackages = [ ];

  # Homebrew configuration for GUI applications and macOS-specific tools
  homebrew = {
    enable = true;

    # Activation settings
    onActivation = {
      cleanup = "zap"; # Aggressive cleanup - removes unlisted casks
      autoUpdate = true; # Auto-update Homebrew on activation
    };

    user = constants.user.name;

    # Homebrew taps for additional packages
    taps = [
      "nikitabobko/homebrew-aerospace" # Aerospace window manager
      "FelixKratz/homebrew-formulae" # Additional tools
    ];

    # Homebrew formulae (CLI tools better managed by Homebrew)
    brews = [
      "claude-squad" # Claude CLI tools
    ];

    # Homebrew casks (GUI applications)
    casks = [
      # Terminal & Development
      "ghostty@tip" # Modern terminal emulator (nightly build)
      "visual-studio-code" # Code editor

      # Productivity & Utilities
      "raycast" # Spotlight replacement & productivity launcher
      "shottr" # Screenshot tool
      "keka" # Archive manager
      "rectangle-pro" # Window management
      "betterdisplay" # Display management for external monitors

      # System Enhancement
      "karabiner-elements" # Keyboard customization
      "aerospace" # Tiling window manager

      # Communication
      "discord" # Voice & text chat
      "slack" # Team communication

      # Web & Network
      "google-chrome" # Web browser
      "tailscale-app" # VPN/mesh networking

      # Fonts (Nerd Fonts for terminal use)
      "font-udev-gothic-nf" # UDev Gothic Nerd Font
      "font-plemol-jp-nf" # PlemolJP Nerd Font (Japanese)
      "font-nanum-gothic-coding" # Nanum Gothic Coding (Korean)
    ];
  };

  # Nix configuration
  nix.settings = {
    experimental-features = "nix-command flakes"; # Enable flakes

    # Optional: Add binary caches for faster builds
    # substituters = [
    #   "https://cache.nixos.org"
    #   "https://nix-community.cachix.org"
    # ];
    # trusted-public-keys = [
    #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
  };

  # Alternative shell support (uncomment if needed)
  # programs.fish.enable = true;
  # programs.bash.enable = true;
}
