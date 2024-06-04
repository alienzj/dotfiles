{ options, config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.hidpi;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.hidpi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.dpi = 168;

    # reference
    # https://wiki.archlinuxcn.org/zh-hans/HiDPI
    environment.variables = {
      # QT method: manually
      ##QT_SCALE_FACTOR = "2";
      QT_SCREEN_SCALE_FACTORS = "2;2";
      QT_AUTO_SCREEN_SCALE_FACTOR = "0";

      # QT method: automatically
      #QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      # GTK
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };

    # link recursively so other modules can link files in their folders
    home.configFile."xtheme/80-high-dpi".text = ''
      Xcursor.size: 32
      Xft.dpi: 168
    '';
  };
}