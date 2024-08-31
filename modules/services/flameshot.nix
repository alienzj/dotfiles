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
  cfg = config.modules.services.flameshot;
  iniFormat = pkgs.formats.ini {};
  settings = {
    General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
      savePath = cfg.savePath;
      saveAsFileExtension = ".png";
      ignoreUpdateToVersion = true;
    };
  };
  iniFile = iniFormat.generate "flameshot.ini" settings;
in {
  options.modules.services.flameshot = {
    enable = mkBoolOpt false;
    savePath = mkOpt types.str "~/pictures/flameshot";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      flameshot
      scrot
      shutter

      (makeDesktopItem {
        name = "Flameshot One Monitor";
        desktopName = "Flameshot One Monitor";
        icon = "flameshot";
        exec = "${pkgs.flameshot}/bin/flameshot gui";
      })

      (makeDesktopItem {
        name = "Flameshot Dual Monitor";
        desktopName = "Flameshot Dual Monitor";
        icon = "flameshot";
        exec = "env QT_SCREEN_SCALE_FACTORS=\"1;1\" ${pkgs.flameshot}/bin/flameshot gui";
      })
    ];

    home.configFile = {
      "flameshot/flameshot.ini".source = iniFile;
    };

    systemd.user.services.flameshot = {
      description = "Flameshot daemon";
      after = ["graphical.target"];
      wantedBy = ["graphical.target"];
      serviceConfig = {
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-abort";

        # Sandboxing
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateUsers = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };
  };
}
