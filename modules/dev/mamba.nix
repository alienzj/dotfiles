# reference
## https://wiki.nixos.org/wiki/Python#Using_micromamba
#export MAMBA_ROOT_PREFIX="${cfg.mambaRootPrefix}"
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.mamba;
  #mambafhs = pkgs.buildFHSUserEnv {
  #  name = "mamba-shell";
  #  #targetPkgs = pkgs: (builtins.concatList [[micromamba]]); #cfg.extraPkgs]);
  #  targetPkgs = [pkgs.micromamba]; #cfg.extraPkgs]);
  #  profile = ''
  #    set -e
  #    eval "$(micromamba shell hook --shell=bash)"
  #    export MAMBA_ROOT_PREFIX="/home/alienzj/.mamba"
  #    if ! test -d $MBA_ROOT_PREFIX/envs/env-base; then
  #        micromamba create --yes -q -n env-base
  #    fi
  #    micromamba activate env-base
  #    set +e
  #  '';
  #};
in {
  options.modules.dev.mamba = with types; {
    enable = mkBoolOpt false;
    mambaRootPrefix = mkOpt types.str "~/.mamba";
    extraPkgs = mkOption {
      type = with types; listOf package;
      default = [pkgs.gcc];
      example = literalExpression "with pkgs; [ gcc ]";
      description = ''
        Enabled extra pkgs in mamba environment.
      '';
    };
  };

  #config = mkIf cfg.enable (mambafhs.env);
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (my.mamba.override {
        mambaRootPrefix = cfg.mambaRootPrefix;
        extraPkgs = cfg.extraPkgs;
      })
    ];
  };
}
