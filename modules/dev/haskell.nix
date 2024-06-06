{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      haskell.compiler.native-bignum.ghcHEAD
      haskellPackages.haskell-language-server
      haskellPackages.cabal-install
      haskellPackages.hoogle
    ];
  };
}
