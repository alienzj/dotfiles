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
  cfg = config.modules.services.adb;
in {
  options.modules.services.adb = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    #users."${config.user.name}".extraGroups = [ "adbusers" ];
    user.extraGroups = ["adbusers"];
  };
}
