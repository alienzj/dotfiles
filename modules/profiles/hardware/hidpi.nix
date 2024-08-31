# modules.hardware.hidpi --- special support for hidpi displays
#
# TODO
{
  hey,
  lib,
  config,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "hidpi" config.modules.profiles.hardware) {
    #environment.sessionVariables = {
    #  QT_DEVICE_PIXEL_RATIO = "2";
    #  QT_AUTO_SCREEN_SCALE_FACTOR = "true";
    #};

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
    #Xcursor.size: 32
    home.configFile."xtheme/80-high-dpi".text = ''
      Xft.dpi: 168
    '';
  }
