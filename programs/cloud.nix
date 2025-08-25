# Cloud development tools
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.cloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable cloud development tools";
    };

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

  config = lib.mkIf config.programs.cloud.enable {
    home.packages =
      with pkgs;
      # AWS tools
      lib.optionals config.programs.cloud.enableAWS [
        awscli2
        # aws-vault  # for credential management
      ]
      # Infrastructure as Code
      ++ lib.optionals config.programs.cloud.enableTerraform [
        terraform
      ]
      # Kubernetes tools
      ++ lib.optionals config.programs.cloud.enableKubernetes [
        kubectl
        k9s # Terminal UI for Kubernetes
        # kubectx  # for context switching
      ];

    # Cloud-specific aliases
    programs.zsh.shellAliases = lib.mkMerge [
      (lib.mkIf config.programs.cloud.enableAWS {
        # AWS shortcuts
        # awsl = "aws configure list";
        # awsp = "aws configure list-profiles";
      })
      (lib.mkIf config.programs.cloud.enableKubernetes {
        # Kubernetes shortcuts
        # k = "kubectl";
        # kgp = "kubectl get pods";
        # kgs = "kubectl get services";
      })
    ];
  };
}
