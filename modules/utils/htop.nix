{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.utils.htop;
in {
  options.modules.utils.htop = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.htop
      ];
    }
  ]);
}
