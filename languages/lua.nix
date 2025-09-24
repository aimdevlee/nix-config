# Lua programming language and development tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.lua;
in
{
  options.languages.lua = {
    enable = lib.mkEnableOption "Lua programming language";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.lua;
      defaultText = lib.literalExpression "pkgs.lua";
      description = "Lua package to use";
      example = lib.literalExpression "pkgs.lua5_4";
    };

    enableLuarocks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable LuaRocks package manager";
    };

    enableLuaJIT = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use LuaJIT instead of standard Lua";
    };

    tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable common Lua development tools";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          stylua # Lua code formatter
          selene # Lua linter written in Rust
          luaformatter # Alternative Lua formatter
        ];
        defaultText = lib.literalExpression ''
          with pkgs; [
            stylua
            selene
            luaformatter
          ]
        '';
        description = "Lua development tools to install";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.luajitPackages.luacheck ]";
      description = "Extra packages to install alongside Lua";
    };

    rocks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "busted"
        "ldoc"
        "penlight"
      ];
      description = "Lua rocks to install via LuaRocks (requires enableLuarocks)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        (if cfg.enableLuaJIT then luajit else cfg.package)
      ]
      ++ lib.optional (cfg.enableLuarocks && !cfg.enableLuaJIT) luarocks
      ++ lib.optional (cfg.enableLuarocks && cfg.enableLuaJIT) luajitPackages.luarocks
      ++ lib.optionals cfg.tools.enable cfg.tools.packages
      ++ cfg.extraPackages;

    home.sessionVariables = lib.mkIf cfg.enableLuarocks {
      LUA_PATH = "$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;;";
      LUA_CPATH = "$HOME/.luarocks/lib/lua/5.1/?.so;;";
    };

    home.sessionPath = lib.optional cfg.enableLuarocks "$HOME/.luarocks/bin";

    # Install Lua rocks after activation if specified
    home.activation = lib.mkIf (cfg.enableLuarocks && cfg.rocks != [ ]) {
      installLuaRocks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if command -v luarocks >/dev/null 2>&1; then
          echo "Installing Lua rocks..."
          ${lib.concatMapStringsSep "\n" (rock: ''
            luarocks install --local ${rock} || echo "Failed to install ${rock}"
          '') cfg.rocks}
        fi
      '';
    };

    # Lua-specific shell aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      luafmt = "stylua";
      luacheck = "selene";
      luarepl = if cfg.enableLuaJIT then "luajit" else "lua";
    };
  };
}
