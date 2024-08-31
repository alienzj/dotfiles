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
  cfg = config.modules.desktop.im.tdesktop;
in {
  options.modules.desktop.im.tdesktop = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      tdesktop
    ];
  };
}
