{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.apps.scrcpy;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.scrcpy = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      scrcpy
    ];
  };
}
