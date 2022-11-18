{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.input.fcitx;
in {
  options.modules.desktop.input.fcitx = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx.engines = with pkgs.fcitx-engines; [ rime ];
      };
      
      #i18n.inputMethod = {
      #  enabled = "ibus";
      #  ibus.engines = with pkgs.ibus-engines; [ rime ];
      #};
    }
  ]);
}
