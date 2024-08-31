# Zeal is an offline documentation browser for software developers.
{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
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
