# reference
## https://github.com/betterlockscreen/betterlockscreen
## TODO
## betterlockscreen -u modules/themes/alucard/config/wallpaper.png --display 1 -u ~/pictures/The_hunt_for_a_healthy_microbiome.webp --display 2
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
      default = 20;
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
          exec = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --dimblur --lock";
        })

        (makeDesktopItem {
          name = "better-lock-and-sleep";
          desktopName = "Better Lock screen and Sleep";
          icon = "system-lock-screen";
          exec = "${pkgs.betterlockscreen}/bin/betterlockscreen --suspend";
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
          ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --dimblur --lock";
          TimeoutSec = "infinity";
        };
      };

      ## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/xautolock.nix
      services.xserver.xautolock = {
        enable = true;
        time = cfg.inactiveInterval;
        locker = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall --dimblur --lock";
        #killer = "/run/current-system/systemd/bin/systemctl suspend";
      };
    }
  ]);
}
