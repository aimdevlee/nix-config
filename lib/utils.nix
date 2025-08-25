# Utility functions for nix-darwin configuration
{ lib }:
{
  # Helper to create optional packages based on condition
  mkOptionalPackage = condition: pkg: lib.optionals condition [ pkg ];

  mkOptionalPackages = condition: pkgs: lib.optionals condition pkgs;

  # Common option builders for consistency
  mkBoolOption =
    default: description:
    lib.mkOption {
      type = lib.types.bool;
      inherit default description;
    };

  mkStringOption =
    default: description:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
    };

  mkEnumOption =
    values: default: description:
    lib.mkOption {
      type = lib.types.enum values;
      inherit default description;
    };
}
