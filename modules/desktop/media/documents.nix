# modules/desktop/media/docs.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.documents;
in {
  options.modules.desktop.media.documents = {
    enable = mkBoolOpt false;
    pdf.enable = mkBoolOpt false;
    ebook.enable = mkBoolOpt false;
    file.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs;
        (
          if cfg.ebook.enable
          #then [calibre librum]
          then [calibre koreader]
          else []
        )
        ++ (
          if cfg.pdf.enable
          then [evince sioyek poppler_utils pdfarranger]
          else []
        );
    }

    (mkIf cfg.file.enable {
      services.gvfs.enable = true;
      services.tumbler.enable = true;

      programs.dconf.enable = true;
      programs.xfconf.enable = true;

      programs.thunar.enable = true;
      programs.thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    })

    # TODO calibre/evince/zathura dotfiles
  ]);
}
