# Rust programming language and development tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.rust;
in
{
  options.languages.rust = {
    enable = lib.mkEnableOption "Rust programming language";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rustc;
      defaultText = lib.literalExpression "pkgs.rustc";
      description = "Rust compiler package to use";
    };

    enableRustup = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use rustup instead of nixpkgs Rust (allows toolchain management)";
    };

    enableCargo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Cargo package manager";
    };

    enableClippy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Clippy linter";
    };

    enableRustfmt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable rustfmt code formatter";
    };

    tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable common Rust development tools";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          cargo-edit # Add/remove/upgrade dependencies
          cargo-watch # Watch for changes and rebuild
          cargo-expand # Expand macros
          cargo-outdated # Check for outdated dependencies
          cargo-audit # Audit dependencies for security vulnerabilities
          cargo-nextest # Next-generation test runner
          cargo-machete # Find unused dependencies
          sccache # Shared compilation cache
        ];
        defaultText = lib.literalExpression ''
          with pkgs; [
            cargo-edit
            cargo-watch
            cargo-expand
            cargo-outdated
            cargo-audit
            cargo-nextest
            cargo-machete
            sccache
          ]
        '';
        description = "Rust development tools to install";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.wasm-pack ]";
      description = "Extra packages to install alongside Rust";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      # If rustup is enabled, don't install individual rust components
      if cfg.enableRustup then
        [ rustup ] ++ lib.optionals cfg.tools.enable cfg.tools.packages ++ cfg.extraPackages
      else
        [ cfg.package ]
        ++ lib.optional cfg.enableCargo cargo
        ++ lib.optional cfg.enableClippy clippy
        ++ lib.optional cfg.enableRustfmt rustfmt
        ++ lib.optionals cfg.tools.enable cfg.tools.packages
        ++ cfg.extraPackages;

    home.sessionPath = [ "$HOME/.cargo/bin" ];

    home.sessionVariables = {
      CARGO_HOME = "$HOME/.cargo";
    }
    // lib.optionalAttrs cfg.enableRustup {
      RUSTUP_HOME = "$HOME/.rustup";
    }
    // lib.optionalAttrs (builtins.elem pkgs.sccache (cfg.tools.packages ++ cfg.extraPackages)) {
      RUSTC_WRAPPER = "sccache";
    };

    # Rust-specific shell aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      cb = "cargo build";
      cbr = "cargo build --release";
      cc = "cargo check";
      ccl = "cargo clippy";
      cf = "cargo fmt";
      cr = "cargo run";
      crr = "cargo run --release";
      ct = "cargo test";
      ctn = "cargo nextest run";
      cu = "cargo update";
      ca = "cargo add";
      crm = "cargo rm";
      cw = "cargo watch";
      cdoc = "cargo doc --open";
      cclean = "cargo clean";
      cbench = "cargo bench";
      caudit = "cargo audit";
      coutdated = "cargo outdated";
      cmachete = "cargo machete";
    };
  };
}
