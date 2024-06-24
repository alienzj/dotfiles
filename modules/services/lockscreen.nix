# reference
## https://github.com/betterlockscreen/betterlockscreen
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.lockscreen;
in {
  options.modules.services.lockscreen = {
    enable = mkBoolOpt false;
    inactiveInterval = mkOption {
      type = types.int;
      default = 10;
    };
    arguments = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        betterlockscreen

        (makeDesktopItem {
          name = "better-lock-display";
          desktopName = "Better Lock screen";
          icon = "system-lock-screen";
          exec = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --blur --lock";
        })

        (makeDesktopItem {
          name = "going-to-sleep";
          desktopName = "Systemd Sleep";
          icon = "system-sleep";
          exec = "systemctl suspend";
        })
      ];

      #services.screen-locker = {
      #  enable = true;
      #  inactiveInterval = cfg.inactiveInterval;
      #  lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock ${
      #    concatStringsSep " " cfg.arguments
      #  }";
      #};

      ## https://github.com/betterlockscreen/betterlockscreen/blob/next/system/betterlockscreen%40.service
      systemd.services.betterlockscreen = {
        description = "Lock screen when going to sleep/suspend";
        before = ["sleep.target" "suspend.target"];
        wantedBy = ["sleep.target" "suspend.target"];
        serviceConfig = {
          Type = "simple";
          Environment = "DISPLAY=:0";
          ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --blur --lock";
          TimeoutSec = "infinity";
        };
      };

      ## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/xautolock.nix
      services.xserver.xautolock = {
        enable = true;
        time = 25;
        locker = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --blur --lock";
        #killer = "/run/current-system/systemd/bin/systemctl suspend";
      };
    }
  ]);
}
