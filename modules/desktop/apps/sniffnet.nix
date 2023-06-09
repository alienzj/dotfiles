{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.sniffnet;
in {
  options.modules.desktop.apps.sniffnet = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.sniffnet
      unstable.zenith
    ];
  };
}
