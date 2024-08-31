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
  cfg = config.modules.services.earlyoom;
in {
  options.modules.services.earlyoom = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.earlyoom.enable = true;
  };
}
