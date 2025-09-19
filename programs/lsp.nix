# Language Server Protocol (LSP) servers for various languages
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.lsp;

  # Define available language servers with their packages
  languageServers = {
    lua = [ pkgs.lua-language-server ];
    typescript = [
      pkgs.typescript-language-server
      pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    ];
    go = [ pkgs.gopls ];
    nix = [ pkgs.nil ];
    python = [ pkgs.pyright ];
    rust = [ pkgs.rust-analyzer ];
    markdown = [ pkgs.marksman ];
    yaml = [ pkgs.yaml-language-server ];
    dockerfile = [ pkgs.dockerfile-language-server-nodejs ];
    bash = [ pkgs.bash-language-server ];
  };
in
{
  options.programs.lsp = {
    enable = lib.mkEnableOption "language servers for development";

    languages = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames languageServers));
      default = [
        "lua"
        "typescript"
        "go"
        "nix"
      ];
      example = [
        "python"
        "rust"
        "typescript"
      ];
      description = "List of languages to install LSP servers for";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.terraform-ls ]";
      description = "Additional LSP packages to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.flatten (map (lang: languageServers.${lang} or [ ]) cfg.languages) ++ cfg.extraPackages;
  };
}
