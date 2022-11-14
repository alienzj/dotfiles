# modules/noter/zotero.nix --- https://www.zotero.org
#
# Zotero is a free and open-source reference management software to manage
# bibliographic data and related research materials, such as PDF files.


{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.noter.zotero;
in {
  options.modules.desktop.noter.zotero = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.zotero
      ];
    }
  ]);
}
