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
  cfg = config.modules.desktop.apps.sing-box;
in {
  options.modules.desktop.apps.sing-box = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      sing-box
      nekoray
      v2ray
      v2raya
    ];
  };
}
