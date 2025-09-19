# Common system configuration for all hosts
{
  inputs,
  ...
}:
{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = "nix-command flakes";

      # Performance optimization
      max-jobs = "auto"; # Use all available CPU cores
      cores = 4; # Limit parallel builds to prevent system overload
      keep-outputs = true; # Keep build outputs for debugging
      keep-derivations = true; # Protect from garbage collection

      # Binary caches for faster downloads
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Automatic store optimization (darwin-specific)
    optimise.automatic = true;

    # Automatic garbage collection
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      }; # Weekly on Sunday at 3 AM
      options = "--delete-older-than 14d";
    };
  };

  # System packages available to all users
  environment.systemPackages = [ ];

  # Homebrew configuration shared by all hosts
  homebrew = {
    enable = true;
    # user is set in each host's system.nix

    # Activation settings
    onActivation = {
      autoUpdate = false; # Manual update for better performance
      cleanup = "zap"; # Less aggressive cleanup
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
    ];

    # Common GUI applications for all hosts
    casks = [
      # Terminal & Development
      "ghostty" # Modern terminal emulator
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Git configuration for darwin-version
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # System state version
  system.stateVersion = 6;
}
