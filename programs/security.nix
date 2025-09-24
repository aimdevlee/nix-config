# Security and secrets management tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.security;
in
{
  options.programs.security = {
    enable = lib.mkEnableOption "security and secrets management tools";

    secrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable secrets management tools";
      };

      tools = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "sops"
            "age"
            "vault"
            "pass"
          ]
        );
        default = [ "sops" ];
        example = [
          "sops"
          "age"
        ];
        description = "Secrets management tools to install";
      };
    };

    scanning = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable security scanning tools";
      };

      tools = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "gitleaks"
            "trivy"
            "semgrep"
            "trufflehog"
          ]
        );
        default = [ "gitleaks" ];
        example = [
          "gitleaks"
          "trivy"
        ];
        description = "Security scanning tools to install";
      };
    };

    certificates = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable certificate management tools";
      };

      tools = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "mkcert"
            "step-cli"
            "certbot"
          ]
        );
        default = [ "mkcert" ];
        example = [
          "mkcert"
          "step-cli"
        ];
        description = "Certificate management tools to install";
      };
    };

    passwords = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable password management tools";
      };

      bitwarden = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Bitwarden CLI";
      };

      onePassword = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable 1Password CLI";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.gnupg pkgs.yubikey-manager ]";
      description = "Additional security packages to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      # Secrets management tools
      lib.optionals cfg.secrets.enable (
        map (
          tool:
          if tool == "sops" then
            sops
          else if tool == "age" then
            age
          else if tool == "vault" then
            vault
          else if tool == "pass" then
            pass
          else
            null
        ) cfg.secrets.tools
      )
      # Security scanning tools
      ++ lib.optionals cfg.scanning.enable (
        map (
          tool:
          if tool == "gitleaks" then
            gitleaks
          else if tool == "trivy" then
            trivy
          else if tool == "semgrep" then
            semgrep
          else if tool == "trufflehog" then
            trufflehog
          else
            null
        ) cfg.scanning.tools
      )
      # Certificate management tools
      ++ lib.optionals cfg.certificates.enable (
        map (
          tool:
          if tool == "mkcert" then
            mkcert
          else if tool == "step-cli" then
            step-cli
          else if tool == "certbot" then
            certbot
          else
            null
        ) cfg.certificates.tools
      )
      # Password management tools
      ++ lib.optional (cfg.passwords.enable && cfg.passwords.bitwarden) bitwarden-cli
      ++ lib.optional (cfg.passwords.enable && cfg.passwords.onePassword) _1password
      # Extra packages
      ++ cfg.extraPackages;

    # Security-related shell aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      # Secrets management
      sops-edit = lib.mkIf (builtins.elem "sops" cfg.secrets.tools) "sops --config .sops.yaml";
      age-enc = lib.mkIf (builtins.elem "age" cfg.secrets.tools) "age -e -r";
      age-dec = lib.mkIf (builtins.elem "age" cfg.secrets.tools) "age -d";

      # Security scanning
      gitleaks-scan = lib.mkIf (builtins.elem "gitleaks" cfg.scanning.tools) "gitleaks detect --source . -v";
      trivy-scan = lib.mkIf (builtins.elem "trivy" cfg.scanning.tools) "trivy fs .";

      # Certificate management
      cert-gen = lib.mkIf (builtins.elem "mkcert" cfg.certificates.tools) "mkcert -install && mkcert";
    };

    # Environment variables for security tools
    home.sessionVariables = lib.mkMerge [
      (lib.mkIf (cfg.secrets.enable && builtins.elem "sops" cfg.secrets.tools) {
        SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
      })
      (lib.mkIf (cfg.passwords.enable && cfg.passwords.bitwarden) {
        BW_SESSION_FILE = "$HOME/.config/bitwarden/session";
      })
    ];
  };
}
