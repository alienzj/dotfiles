# Zeal is an offline documentation browser for software developers.
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.zeal;
in {
  options.modules.dev.zeal = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = [
        pkgs.unstable.zeal
        #pkgs.unstable.zeal-qt6
      ];
    }
  ]);
}
