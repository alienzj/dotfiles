# profiles/hardware/eniac.nix --- TODO
{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with builtins;
with lib;
with hey.lib;
  mkIf (elem "eniac" config.modules.profiles.hardware) {
    #services.udev.extraRules = ''
    #  # keyboard autosuspand
    #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend}="-1"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/control}="on"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend_delay_ms}="3600000"

    #  # mouse autosuspand
    #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend}="-1"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/control}="on"
    #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend_delay_ms}="3600000"
    #'';

    # Displays
    services.xserver = {
      enable = true;
      exportConfiguration = true;
      xkb.layout = "us";
      serverFlagsSection = ''
        Option "StandbyTime" "20"
        Option "SuspendTime" "30"
        Option "OffTime" "45"
        Option "BlankTime" "45"
      '';
    };

    services.xserver.displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output HDMI-0 --mode 3840x2160 --rate 60 --pos 0x0 --primary
    '';
}
