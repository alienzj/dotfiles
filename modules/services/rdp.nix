{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.rdp;
in {
  options.modules.services.rdp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # services.xserver.enable = true;
      # services.xserver.displayManager.sddm.enable = true;
      # services.desktopManager.plasma6.enable = true;

      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "none+bspwm";
      networking.firewall.allowedTCPPorts = [ 3389 ];
      # Soon: services.xrdp.openFirewall = true;
    }
  ]);
}
