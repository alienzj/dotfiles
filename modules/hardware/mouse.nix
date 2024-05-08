{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.mouse;
in {
  options.modules.hardware.mouse = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.lan-mouse
    ];
  };
}
