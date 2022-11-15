{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.noter.calibre;
in {
  options.modules.desktop.noter.calibre = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.calibre
      ];
    }
  ]);
}
