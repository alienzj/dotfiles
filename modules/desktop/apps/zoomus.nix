{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.apps.zoomus;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.zoomus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      zoom-us
    ];

    home.configFile = {
      "zoomus.conf".source = "${hey.configDir}/zoomus/zoomus.conf";
    };
  };
}
