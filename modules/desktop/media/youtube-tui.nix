{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.youtube-tui;
in {
  options.modules.desktop.media.youtube-tui = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      youtube-tui
    ];
  };
}
