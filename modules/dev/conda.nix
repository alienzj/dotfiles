# reference
## http://www.jaakkoluttinen.fi/blog/conda-on-nixos/
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/conda/default.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.conda;
in {
  options.modules.dev.conda = with types; {
    enable = mkBoolOpt false;
    installationPath = mkOpt types.str "~/.conda/envs/env-base";
    extraPkgs = mkOption {
      type = with types; listOf package;
      default = [pkgs.gcc];
      example = literalExpression "with pkgs; [ gcc ]";
      description = ''
        Enabled extra pkgs in conda environment.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        (conda.override {
          installationPath = cfg.installationPath;
          extraPkgs = cfg.extraPkgs;
        })
      ];
    }
  ]);
}
