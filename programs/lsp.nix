# Language Server Protocol (LSP) servers for various languages
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.lsp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable language servers for development";
    };

    languages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "lua"
        "typescript"
        "go"
        "nix"
      ];
      description = "List of languages to install LSP servers for";
    };
  };

  config = lib.mkIf config.programs.lsp.enable {
    home.packages =
      with pkgs;
      lib.optionals (lib.elem "lua" config.programs.lsp.languages) [ lua-language-server ]
      ++ lib.optionals (lib.elem "typescript" config.programs.lsp.languages) [
        typescript-language-server
        vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      ]
      ++ lib.optionals (lib.elem "go" config.programs.lsp.languages) [ gopls ]
      ++ lib.optionals (lib.elem "nix" config.programs.lsp.languages) [ nil ]
      ++ lib.optionals (lib.elem "python" config.programs.lsp.languages) [ pyright ]
      ++ lib.optionals (lib.elem "rust" config.programs.lsp.languages) [ rust-analyzer ];
  };
}
