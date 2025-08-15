# Shell aliases configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.aliases;
in
{
  options.modules.shell.aliases = {
    enable = lib.mkEnableOption "shell aliases";

    enableEza = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use eza for better ls output";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.optional cfg.enableEza eza;

    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable (
      {
        # Navigation shortcuts
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        # Nix shortcuts
        ns = "sudo darwin-rebuild switch";
        nfu = "nix flake update";
        nfc = "nix flake check";
        nfmt = "nix fmt";

        # Editor shortcuts
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        # Tmux shortcuts
        t = "tmux";
        ta = "tmux attach";
        tn = "tmux new-session -s";
        tl = "tmux list-sessions";

        # System shortcuts
        reload = "source ~/.zshrc";
        path = "echo $PATH | tr ':' '\n'";

        # Claude Code alias
        claude = "npx @anthropic-ai/claude-code";
      }
      // lib.optionalAttrs cfg.enableEza {
        # Eza aliases (better ls)
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";
        lla = "eza -la --git";
        llt = "eza -l --tree";
      }
    );
  };
}
