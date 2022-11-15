{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.im.whatsapp;
in {
  options.modules.desktop.im.whatsapp = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.whatsapp-for-linux
    ];
  };
}
