{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.netapplet;
in {
  options.modules.desktop.apps.netapplet = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    #programs.nm-applet.enable = true;
    user.packages = with pkgs; [
      networkmanagerapplet
      networkmanager_dmenu
      rofi-vpn
    ];
    user.extraGroups = [ "networkmanager" ];
  };
}
