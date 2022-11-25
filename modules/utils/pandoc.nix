{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.utils.pandoc;
in {
  options.modules.utils.pandoc = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.pandoc
    ];
  };
}
