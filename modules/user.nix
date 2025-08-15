# User-specific configuration module
{ config, lib, pkgs, ... }:
let
  constants = import ../lib/default.nix { inherit lib pkgs; };
in
{
  options.modules.user = {
    enable = lib.mkEnableOption "user configuration module";
    
    name = lib.mkOption {
      type = lib.types.str;
      default = constants.user.name;
      description = "Username for the system";
    };
    
    email = lib.mkOption {
      type = lib.types.str;
      default = constants.user.email;
      description = "User email for Git and other configurations";
    };
    
    homeDirectory = lib.mkOption {
      type = lib.types.str;
      default = constants.user.homeDirectory;
      description = "User home directory path";
    };
    
    enableGitSigning = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SSH signing for Git commits";
    };
    
    sshSigningKey = lib.mkOption {
      type = lib.types.str;
      default = "~/.ssh/id_ed25519.pub";
      description = "Path to SSH public key for signing";
    };
  };

  config = lib.mkIf config.modules.user.enable {
    # Git configuration
    programs.git = {
      enable = true;
      userName = config.modules.user.name;
      userEmail = config.modules.user.email;
      
      # SSH signing configuration
      extraConfig = lib.mkIf config.modules.user.enableGitSigning {
        commit.gpgsign = true;
        tag.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = config.modules.user.sshSigningKey;
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
    
    # Create allowed_signers file for SSH signing verification
    home.activation.sshSigningSetup = lib.mkIf config.modules.user.enableGitSigning (
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f ${config.modules.user.homeDirectory}/.ssh/id_ed25519.pub ]; then
          echo "${config.modules.user.email} namespaces=\"git\" $(cat ${config.modules.user.homeDirectory}/.ssh/id_ed25519.pub)" > ${config.modules.user.homeDirectory}/.ssh/allowed_signers
          echo "Created SSH allowed_signers file"
        fi
      ''
    );

    # Environment variables
    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.modules.user.homeDirectory}/.config";
    };
  };
}