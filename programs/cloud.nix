# Cloud development tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.cloud;
in
{
  options.programs.cloud = {
    enable = lib.mkEnableOption "cloud development tools";

    aws = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable AWS CLI and tools";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.aws-vault pkgs.eksctl ]";
        description = "Additional AWS-related packages";
      };
    };

    terraform = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Terraform for infrastructure as code";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.terraform;
        defaultText = lib.literalExpression "pkgs.terraform";
        description = "Terraform package to use";
      };
    };

    kubernetes = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Kubernetes tools";
      };

      tools = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "kubectl"
            "k9s"
            "helm"
            "kubectx"
            "stern"
          ]
        );
        default = [
          "kubectl"
          "k9s"
        ];
        example = [
          "kubectl"
          "k9s"
          "helm"
          "kubectx"
        ];
        description = "Kubernetes tools to install";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      # AWS tools
      lib.optionals cfg.aws.enable ([ awscli2 ] ++ cfg.aws.extraPackages)
      # Infrastructure as Code
      ++ lib.optional cfg.terraform.enable cfg.terraform.package
      # Kubernetes tools
      ++ lib.optionals cfg.kubernetes.enable (
        map (
          tool:
          if tool == "kubectl" then
            kubectl
          else if tool == "k9s" then
            k9s
          else if tool == "helm" then
            kubernetes-helm
          else if tool == "kubectx" then
            kubectx
          else if tool == "stern" then
            stern
          else
            null
        ) cfg.kubernetes.tools
      );

    # Cloud-specific aliases
    programs.zsh.shellAliases = lib.mkMerge [
      (lib.mkIf cfg.aws.enable { })
      (lib.mkIf cfg.kubernetes.enable { })
    ];
  };
}
