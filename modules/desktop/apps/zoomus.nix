{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.zoomus;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.zoomus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      zoom-us
    ];

    home.configFile = {
      "zoomus.conf".source = "${configDir}/zoomus/zoomus.conf";
    };
  };
}
