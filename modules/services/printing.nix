{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.printing;
in {
  options.modules.services.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.printing = {
        enable = true;
        #drivers = [ pkgs.epson-escpr ];
      };
    }
  ]);
}
