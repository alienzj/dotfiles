{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.geph;
in {
  options.modules.desktop.apps.geph = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      #pkgs.unstable.geph.gui
      pkgs.unstable.geph.cli
    ];
  };
}
