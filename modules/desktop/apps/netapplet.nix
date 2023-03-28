{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.netapplet;
in {
  options.modules.desktop.apps.netapplet = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      networkmanagerapplet
      rofi-vpn
    ];
  };
}
