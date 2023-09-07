{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.utils.disk;
in {
  options.modules.utils.disk = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.diskus
      unstable.lfs
      unstable.pigz
    ];
  };
}
