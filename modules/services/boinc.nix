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
  cfg = config.modules.services.boinc;
in {
  options.modules.services.boinc = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.boinc = {
      enable = true;
      dataDir = "/var/lib/boinc"; # default location where data is stored
    };
  };
}
