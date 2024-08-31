{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.apps.geph;
in {
  options.modules.desktop.apps.geph = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      geph.gui
      geph.cli

      # https://github.com/tauri-apps/tauri/issues/4315
      (makeDesktopItem {
        name = "Geph-gui";
        desktopName = "Geph GUI";
        genericName = "Open Geph GUI";
        icon = "io.geph.GephGui";
        exec = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 GDK_SCALE=1 ${geph.gui}/bin/gephgui-wry";
        categories = ["Network"];
      })
    ];
  };
}
