# Host-specific system configuration for aimdevlee
_: {
  # Homebrew user for this host
  homebrew.user = "aimdevlee";

  # Host-specific Homebrew packages
  homebrew.casks = [
    "rectangle-pro" # Window management
    "betterdisplay" # Display management for external monitors
    "discord" # Voice & text chat
    "slack" # Team communication
    "tailscale-app" # VPN/mesh networking
    "shottr" # Screenshot tool
    "keka" # Archive manager
  ];

  # Host-specific system settings can be added here
  # system.defaults.dock.autohide = true;
}
