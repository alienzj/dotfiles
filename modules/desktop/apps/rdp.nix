{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.rdp;
in {
  options.modules.desktop.apps.rdp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      remmina
      freerdp
    ];
  };
}
