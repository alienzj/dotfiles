{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.netease-cloud-music;
in {
  options.modules.desktop.media.netease-cloud-music = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.netease-music-tui
      unstable.netease-cloud-music-gtk
    ];
  };
}
