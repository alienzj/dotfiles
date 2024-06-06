{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.gaming.games;
in {
  options.modules.desktop.gaming.games = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      #worldofgoo
      mari0
      mar1d
    ];
  };
}
