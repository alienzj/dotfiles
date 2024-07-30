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
      cpufetch
      cpu-x

      # hardware
      unstable.hardinfo

      # recourse
      unstable.mission-center
      unstable.resources
      unstable.btop

      # disk
      gnome-disk-utility
    ];

    home.configFile = {
      "neofetch/config.conf".source = "${configDir}/neofetch/neofetch.conf";
    };
  };
}
