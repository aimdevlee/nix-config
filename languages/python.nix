# Python programming language and development tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.python;
in
{
  options.languages.python = {
    enable = lib.mkEnableOption "Python programming language";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python3;
      defaultText = lib.literalExpression "pkgs.python3";
      description = "Python package to use";
      example = lib.literalExpression "pkgs.python311";
    };

    enablePoetry = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Poetry for dependency management";
    };

    enablePipx = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pipx for installing Python applications in isolated environments";
    };

    enableVirtualenv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable virtualenv for creating isolated Python environments";
    };

    enableBlack = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Black code formatter";
    };

    enableRuff = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Ruff linter (fast Python linter)";
    };

    enableMypy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mypy type checker";
    };

    tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable common Python development tools";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs.python3Packages; [
          pip
          setuptools
          wheel
          pytest
          ipython
        ];
        defaultText = lib.literalExpression ''
          with pkgs.python3Packages; [
            pip
            setuptools
            wheel
            pytest
            ipython
          ]
        '';
        description = "Python packages to install";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.python3Packages.numpy ]";
      description = "Extra Python packages to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ cfg.package ]
      ++ lib.optional cfg.enablePoetry poetry
      ++ lib.optional cfg.enablePipx pipx
      ++ lib.optional cfg.enableVirtualenv python3Packages.virtualenv
      ++ lib.optional cfg.enableBlack black
      ++ lib.optional cfg.enableRuff ruff
      ++ lib.optional cfg.enableMypy mypy
      ++ lib.optionals cfg.tools.enable cfg.tools.packages
      ++ cfg.extraPackages;

    home.sessionVariables = {
      # Prevent Python from creating .pyc files
      PYTHONDONTWRITEBYTECODE = "1";
      # Enable Python development mode for better error messages
      PYTHONDEVMODE = "1";
    };

    # Python-specific shell aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      py = "python3";
      ipy = "ipython";
      pyvenv = "python3 -m venv";
      pyactivate = "source venv/bin/activate";
      pyclean = "find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true";
      pyfreeze = "pip freeze > requirements.txt";
      pyinstall = "pip install -r requirements.txt";
      pytest = "python -m pytest";
      pyupgrade = "pip install --upgrade pip setuptools wheel";
    };
  };
}
