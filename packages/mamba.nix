# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/conda/default.nix
{
  self,
  lib,
  pkgs,
  buildFHSEnv,
  mambaRootPrefix ? "~/.mamba",
  extraPkgs ? [],
}:
# simply call `mamba-shell` to activate the FHS env,
# and then use micromamba commands as normal:
# $ mamba-shell
# $ micromamba install snakemake
let
  name = "mamba";
in
  buildFHSEnv {
    name = "mamba-shell";
    targetPkgs = pkgs: (builtins.concatLists [[pkgs.micromamba] extraPkgs]);
    profile = ''
      set -e
      eval "$(micromamba shell hook --shell=posix)"
      export MAMBA_ROOT_PREFIX="${mambaRootPrefix}"
      if ! test -d $MAMBA_ROOT_PREFIX/envs/env-base; then
          micromamba create --yes -q -n env-base
      fi
      micromamba activate env-base
      set +e
    '';

    runScript = "bash -l";

    meta = {
      description = "Reimplementation of the conda package manager";
      mainProgram = "mamba-shell";
      homepage = "https://github.com/mamba-org/mamba";
      platforms = lib.platforms.linux;
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [];
    };
  }
