{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.stumpwm;
in {
  options.modules.desktop.stumpwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
    ];

    # master.services.picom.enable = true;
    services = {
      redshift.enable = true;
      xserver = {
        enable = true;
        #windowManager.default = "stumpwm";
        windowManager.stumpwm.enable = true;
        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeters.mini.enable = true;
      };
    };

    # link recursively so other modules can link files in their folders
    home.configFile."stumpwm" = {
      source = "${hey.configDir}/stumpwm";
      recursive = true;
    };
  };
}
