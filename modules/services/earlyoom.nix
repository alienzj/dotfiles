{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.earlyoom;
in {
  options.modules.services.earlyoom = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.earlyoom.enable = true;
  };
}
