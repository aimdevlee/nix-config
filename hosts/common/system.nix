# Common system configuration for all hosts
{
  inputs,
  ...
}:
{
  # Nix configuration
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # System packages available to all users
  environment.systemPackages = [ ];

  # Homebrew configuration shared by all hosts
  homebrew = {
    enable = true;
    # user is set in each host's system.nix

    # Activation settings
    onActivation = {
      autoUpdate = true; # Auto-update Homebrew on activation
      cleanup = "uninstall"; # Aggressive cleanup - removes unlisted casks
    };

    # Common taps for all hosts
    taps = [
      "nikitabobko/homebrew-aerospace" # Aerospace window manager
      "FelixKratz/homebrew-formulae" # Additional tools
    ];

    # Common CLI tools for all hosts
    brews = [
      # Shell & Terminal
      "tpm" # Tmux plugin manager

      # Cloud & Infrastructure
      "saml2aws" # AWS SAML authentication

      # Security
      "pinentry-mac"
    ];

    # Common GUI applications for all hosts
    casks = [
      # Terminal & Development
      "ghostty@tip" # Modern terminal emulator (nightly build)
      "visual-studio-code" # Code editor

      # Productivity & Utilities
      "raycast" # Spotlight replacement & productivity launcher

      # System Enhancement
      "karabiner-elements" # Keyboard customization
      "aerospace" # Tiling window manager

      # Web & Network
      "google-chrome" # Web browser

      # Fonts (Nerd Fonts for terminal use)
      "font-udev-gothic-nf" # UDev Gothic Nerd Font
      "font-plemol-jp-nf" # PlemolJP Nerd Font (Japanese)
      "font-nanum-gothic-coding" # Nanum Gothic Coding (Korean)
    ];
  };

  # Overlays configuration
  nixpkgs.overlays = import ../../overlays/default.nix { inherit inputs; };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Git configuration for darwin-version
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # System state version
  system.stateVersion = 6;
}
