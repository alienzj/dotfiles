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
  cfg = config.modules.desktop.gaming.games;
in {
  options.modules.desktop.gaming.games = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      #worldofgoo
      mari0
      mar1d
    ];
  };
}
