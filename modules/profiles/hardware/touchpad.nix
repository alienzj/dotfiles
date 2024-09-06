{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  hardware = config.modules.profiles.hardware;
in
  mkIf (any (s: hasPrefix "touchpad" s) hardware) (mkMerge [
    {
      services.libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          clickMethod = "clickfinger";
          naturalScrolling = true;
        };
      };
    }
  ])
