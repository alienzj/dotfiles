# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.documents;
in {
  options.modules.desktop.media.documents = {
    enable = mkBoolOpt false;
    pdf.enable = mkBoolOpt false;
    ebook.enable = mkBoolOpt false;
    file.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        (mkIf cfg.ebook.enable calibre)
        (mkIf cfg.pdf.enable   gnome.evince)
        (mkIf cfg.file.enable  gnome.nautilus)
        # zathura
      ];
    }

    (mkIf (cfg.file.enable) {
      services.gvfs.enable = true;
      programs.dconf.enable = true;
    })

    # TODO calibre/evince/zathura dotfiles
  ]);
}
