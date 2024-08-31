# modules/desktop/media/docs.nix
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
  cfg = config.modules.desktop.media.doc;
in {
  options.modules.desktop.media.doc = {
    enable = mkBoolOpt false;
    pdf.enable = mkBoolOpt false;
    ebook.enable = mkBoolOpt false;
    #file.enable = mkBoolOpt false;
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

    #(mkIf cfg.file.enable {
    #  services.gvfs.enable = true;
    #  services.tumbler.enable = true;
    #
    #  programs.thunar.plugins = with pkgs.xfce; [
    #    thunar-archive-plugin
    #    thunar-volman
    #  ];
    #})

    # TODO calibre/evince/zathura dotfiles
  ]);
}
