{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.usbimager;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.usbimager = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      usbimager
    ];
  };
}
