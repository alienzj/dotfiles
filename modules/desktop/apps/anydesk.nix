{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.anydesk;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.anydesk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      anydesk
    ];
  };
}
