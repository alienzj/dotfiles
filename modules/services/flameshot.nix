{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.flameshot;
  iniFormat = pkgs.formats.ini {};
  settings = {
    General = {
      disabledTrayIcon = false;
      showStartupLaunchMessage = true;
      savePath = "/home/alienzj/pictures/flameshot";
      saveAsFileExtension = ".png";
      ignoreUpdateToVersion = true;
    };
  };
  iniFile = iniFormat.generate "flameshot.ini" settings;
in {
  options.modules.services.flameshot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      flameshot
      scrot
      shutter

      (makeDesktopItem {
        name = "Flameshot Screen";
        desktopName = "Flameshot Screen";
        icon = "flameshot";
        exec = "${pkgs.flameshot}/bin/flameshot gui";
      })

      (makeDesktopItem {
        name = "Flameshot Capture";
        desktopName = "Flameshot Capture";
        icon = "flameshot";
        exec = "env QT_SCREEN_SCALE_FACTORS=\"1;1\" ${pkgs.flameshot}/bin/flameshot gui";
      })
    ];

    home.configFile = {
      "flameshot/flameshot.ini".source = iniFile;
    };

    systemd.user.services.flameshot = {
      description = "flameshot daemon";
      after = ["graphical-session-pre.target" "tray.target"];
      path = [pkgs.flameshot];
      script = ''
        exec flameshot
      '';
    };
  };
}
