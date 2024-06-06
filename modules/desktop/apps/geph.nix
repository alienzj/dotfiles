{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.geph;
in {
  options.modules.desktop.apps.geph = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
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
