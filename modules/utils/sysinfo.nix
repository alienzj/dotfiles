{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.utils.sysinfo;
  configDir = config.dotfiles.configDir;
in {
  options.modules.utils.sysinfo = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # system
      unstable.neofetch

      # cpu
      #cpufetch
      #cpu-x

      # hardware
      #unstable.hardinfo

      # recourse
      #unstable.mission-center
      #unstable.resources
      unstable.btop

      # disk
      #gnome-disk-utility

      unstable.pciutils
      unstable.usbutils
      unstable.lshw

      # Probe for hardware, check operability and find drivers
      # https://github.com/linuxhw/hw-probe
      # https://linux-hardware.org/
      unstable.hw-probe
    ];

    home.configFile = {
      "neofetch/config.conf".source = "${configDir}/neofetch/neofetch.conf";
    };
  };
}
