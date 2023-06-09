{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.file-manager;
in {
  options.modules.desktop.apps.file-manager = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      xplorer
      #spacedrive
      xplr
    ];
  };
}
