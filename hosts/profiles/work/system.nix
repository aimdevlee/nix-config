# Host-specific system configuration for JRXNCW6L5J
_: {
  homebrew = {
    # Homebrew user for this host
    user = "dongbin-lee";

    # Host-specific Homebrew packages
    brews = [
      # Database (host-specific requirement)
      "mysql@8.0"

      # AI Tools (host-specific requirement)
      "ollama"
    ];

    casks = [
      # Database GUI (host-specific requirement)
      "sequel-ace"
    ];
  };

  # Host-specific system settings
  # system.defaults.dock.autohide = false;
}
