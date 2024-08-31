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
  cfg = config.modules.desktop.im.matrix;
in {
  options.modules.desktop.im.matrix = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      element-desktop
      #cinny-desktop
    ];
  };
}
