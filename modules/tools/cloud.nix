# Cloud development tools configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.tools.cloud;
in
{
  options.modules.tools.cloud = {
    enable = lib.mkEnableOption "cloud development tools";

    enableAWS = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable AWS CLI and tools";
    };

    enableTerraform = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Terraform for infrastructure as code";
    };

    enableKubernetes = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kubernetes tools (kubectl, k9s)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      # AWS tools
      ++ lib.optionals cfg.enableAWS [
        awscli2
        # aws-vault for credential management
      ]
      # Infrastructure as Code
      ++ lib.optional cfg.enableTerraform terraform
      # Kubernetes tools
      ++ lib.optionals cfg.enableKubernetes [
        kubectl
        k9s # Terminal UI for Kubernetes
        # kubectx for context switching
      ];

    # Cloud-specific aliases
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable (
      lib.optionalAttrs cfg.enableAWS {
        # AWS shortcuts
        awsl = "aws configure list";
        awsp = "aws configure list-profiles";
      }
      // lib.optionalAttrs cfg.enableKubernetes {
        # Kubernetes shortcuts
        k = "kubectl";
        kgp = "kubectl get pods";
        kgs = "kubectl get services";
        kgd = "kubectl get deployments";
        kdp = "kubectl describe pod";
        klog = "kubectl logs";
      }
    );
  };
}
