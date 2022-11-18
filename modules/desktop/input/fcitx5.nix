{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.input.fcitx5;
in {
  options.modules.desktop.input.fcitx5 = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx.engines = with pkgs; [ rime ];
        fcitx5.enableRimeData = true;
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          fcitx5-mozc
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    }
  ]);
}
