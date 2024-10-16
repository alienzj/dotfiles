{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.gaming.emulators;
in {
  options.modules.desktop.gaming.emulators = {
    psx.enable = mkBoolOpt false; # Playstation
    ds.enable = mkBoolOpt false; # Nintendo DS
    gb.enable = mkBoolOpt false; # GameBoy + GameBoy Color
    gba.enable = mkBoolOpt false; # GameBoy Advance
    snes.enable = mkBoolOpt false; # Super Nintendo
  };

  config = {
    user.packages = with pkgs.unstable; [
      #(mkIf cfg.psx.enable epsxe)
      (mkIf cfg.ds.enable desmume)
      (mkIf (cfg.gba.enable
        || cfg.gb.enable
        || cfg.snes.enable)
      higan)
    ];
  };
}
