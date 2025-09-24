# Personal profile home-manager configuration
_: {
  imports = [
    ../../common/home.nix # Import common home configuration
  ];

  # Personal profile program configurations
  programs = {
    git = {
      userName = "aimdevlee";
      userEmail = "aimdevlee@gmail.com";
    };
    zsh = {
      shellAliases = {
      };
    };

    # Adjust LSP languages to match enabled runtimes
    lsp.languages = [
      "lua"
      "typescript"
      "go"
      "nix"
      "python"
      "rust"
    ];
  };

  # Enable languages for personal development
  languages = {
    go.enable = true;
    python = {
      enable = true;
      enablePoetry = true;
    };
    rust.enable = true;
    lua.enable = true;
  };
  # Personal profile package additions
  # home.packages = with pkgs; [
  #   # Add personal profile packages here
  # ];

  # Personal profile module overrides
  # Example: adjust nodejs version for personal use
  # programs.nodejs.version = "24";
}
