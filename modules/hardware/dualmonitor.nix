{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.dualmonitor;
in {
  options.modules.hardware.dualmonitor = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.variables.DUALMONITOR = "yes";
  };
}
