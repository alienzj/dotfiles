{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.flameshot;
    iniFormat = pkgs.formats.ini { };
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

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [ 
        flameshot

        (makeDesktopItem {
          name = "Flameshot Screen";
          desktopName = "Flameshot Screen";
          icon = "flameshot";
          exec = "${pkgs.flameshot}/bin/flameshot gui";
        })
      ];

      home.configFile = {
        "flameshot/flameshot.ini".source = iniFile;
      };

      #systemd.user.services.flameshot = {
      #  Unit = {
      #    Description = "Flameshot screenshot tool";
      #    Requires = [ "tray.target" ];
      #    After = [ "graphical-session-pre.target" "tray.target" ];
      #    PartOf = [ "graphical-session.target" ];
      #    X-Restart-Triggers = [ "${iniFile}" ];
      #  };

      #  Install = { WantedBy = [ "graphical-session.target" ]; };

      #  Service = {
      #    Environment = "PATH=${config.home.profileDirectory}/bin";
      #    ExecStart = "${pkgs.flameshot}/bin/flameshot";
      #    Restart = "on-abort";

      #    # Sandboxing.
      #    LockPersonality = true;
      #    MemoryDenyWriteExecute = true;
      #    NoNewPrivileges = true;
      #    PrivateUsers = true;
      #    RestrictNamespaces = true;
      #    SystemCallArchitectures = "native";
      #    SystemCallFilter = "@system-service";
      #  };
      #};
    }
  ]);
}
