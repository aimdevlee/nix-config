# Go programming language and development tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.go;
in
{
  options.languages.go = {
    enable = lib.mkEnableOption "Go programming language";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.go;
      defaultText = lib.literalExpression "pkgs.go";
      description = "Go package to use";
      example = lib.literalExpression "pkgs.go_1_21";
    };

    goPath = lib.mkOption {
      type = lib.types.str;
      default = "go";
      description = "GOPATH relative to HOME";
      example = ".go";
    };

    goBin = lib.mkOption {
      type = lib.types.str;
      default = "go/bin";
      description = "Path to Go binaries relative to HOME";
    };

    tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable common Go development tools";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          gotools # goimports, godoc, etc.
          go-tools # staticcheck, etc.
          golangci-lint # Linter aggregator
          delve # Debugger
          gomodifytags # Struct tag modifier
          impl # Generate method stubs
          gotests # Generate tests
          gore # REPL
        ];
        defaultText = lib.literalExpression ''
          with pkgs; [
            gotools
            go-tools
            golangci-lint
            delve
            gomodifytags
            impl
            gotests
            gore
          ]
        '';
        description = "Go development tools to install";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.gopls ]";
      description = "Extra packages to install alongside Go";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ]
    ++ lib.optionals cfg.tools.enable cfg.tools.packages
    ++ cfg.extraPackages;

    home.sessionPath = [ "$HOME/${cfg.goBin}" ];

    home.sessionVariables = {
      GOPATH = "$HOME/${cfg.goPath}";
    };

    # Go-specific shell aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      gomt = "go mod tidy";
      gomv = "go mod vendor";
      gomd = "go mod download";
      gofmt = "gofmt -s -w .";
      gotest = "go test -v ./...";
      gobuild = "go build -v ./...";
      gocover = "go test -coverprofile=coverage.out && go tool cover -html=coverage.out";
    };
  };
}
