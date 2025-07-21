# System-wide configuration for "Dongbin-MacBookPro".
{ pkgs, ... }:
{
  # List packages installed in system profile.
  environment.systemPackages = [ ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    user = "aimdevlee";

    taps = [
      "nikitabobko/homebrew-aerospace"
      "FelixKratz/homebrew-formulae"
    ];

    brews = [
    ];

    casks = [
      "ghostty@tip"
      "discord"
      "visual-studio-code"
      "raycast"
      "karabiner-elements"
      "aerospace"
      "slack"
      "shottr"
      "betterdisplay"
      "keka"
      "rectangle-pro"
      "font-udev-gothic-nf"
      "google-chrome"
      "tailscale-app"
      "battery"
    ];
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support if needed.
  # programs.fish.enable = true;
}
