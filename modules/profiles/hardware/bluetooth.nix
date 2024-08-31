# profiles/hardware/bluetooth.nix --- TODO
#
# TODO
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "bluetooth" config.modules.profiles.hardware) {
    hardware.bluetooth.enable = true;

    services.blueman.enable = true;

    system.activationScripts = {
      rfkillUnblockBluetooth = {
        text = ''
          rfkill unblock bluetooth
        '';
        deps = [];
      };
    };
  }
