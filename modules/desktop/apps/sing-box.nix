{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.sing-box;
in {
  options.modules.desktop.apps.sing-box = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.sing-box

      unstable.nekoray

      unstable.v2ray
      unstable.v2raya
    ];
  };
}
