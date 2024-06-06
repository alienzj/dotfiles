# source:
# https://discourse.nixos.org/t/stop-mouse-from-waking-up-the-computer/12539
# https://raw.githubusercontent.com/9999years/nix-config/main/modules/usb-wakeup-disable.nix
# https://discourse.nixos.org/t/external-mouse-and-keyboard-sleep-when-they-stay-untouched-for-a-few-seconds/14900/12
# Set USB autosuspend to on
# `{ vendor = "...."; product = "...."; }` attrset to the
# `hardware.usb.autosuspendAlwaysOn` configuration option.
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) length;
  inherit
    (lib)
    concatStringsSep
    optionalString
    optional
    toLower
    forEach
    types
    mkOption
    hasInfix
    ;
  cfg = config.hardware.usb.autosuspendAlwaysOn;

  vendorProductStr = types.strMatching "^[0-9a-fA-F]{4}$";

  vendorProductStrDesc = ty: ''
    The device's ${ty} ID, as a 4-digit hex string.

    ${ty} IDs of USB devices can be listed with <code>nix-shell -p usbutils
    --run lsusb</code>, where an output line like <code>Bus 002 Device 003: ID
    046d:c52b Logitech, Inc. Unifying Receiver</code> has a vendor ID of
    <code>046d</code> and a product ID of <code>c52b</code>.

    All strings are converted to lowercase.
  '';

  udevRules =
    pkgs.writeTextDir "etc/udev/rules.d/90-usb-autosuspend-configure.rules"
    (concatStringsSep "\n" (forEach cfg (devCfg: let
      onStr =
        if devCfg.autosuspendOn
        then "on"
        else "auto";
    in
      concatStringsSep ", " [
        ''ACTION=="add"''
        ''ATTRS{idVendor}=="${toLower devCfg.vendor}"''
        ''ATTRS{idProduct}=="${toLower devCfg.product}"''
        ''ATTR{power/control}="${onStr}"''
      ])));
in {
  options.hardware.usb.autosuspendAlwaysOn = mkOption {
    description = "Let USB devices always autosuspend on";
    default = [];
    type = types.listOf (types.submodule {
      options = {
        vendor = mkOption {
          description = vendorProductStrDesc "Vendor";
          type = vendorProductStr;
          example = "046d";
        };
        product = mkOption {
          description = vendorProductStrDesc "Product";
          type = vendorProductStr;
          example = "c52b";
        };
        autosuspendOn = mkOption {
          description = ''
            Is this device allowed autosuspend?
            By default, any devices here are explicitly
            <emphasis>not</emphasis> allowed to autosuspend.
          '';
          type = types.bool;
          default = false;
          example = true;
        };
      };
    });
  };

  config = {services.udev.packages = optional (length cfg != 0) udevRules;};
}
