{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
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
