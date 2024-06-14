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
in {
  options.modules.dev.mamba = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    #{
    #  user.packages = [
    #    pkgs.micromamba
    #  ];
    #}

    (pkgs.buildFHSUserEnv {
      name = "mamba-shell";
      targetPkgs = _: [
        pkgs.micromamba
      ];

      profile = ''
        set -e
        eval "$(micromamba shell hook --shell=posix)"
        export MAMBA_ROOT_PREFIX=~/.mamba
        if ! test -d $MAMBA_ROOT_PREFIX/envs/env-base; then
            micromamba create --yes -q -n env-base
        fi
        micromamba activate env-base
        set +e
      '';
    })
  ]);
}
