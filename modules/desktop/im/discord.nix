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
  cfg = config.modules.desktop.im.discord;
in {
  options.modules.desktop.im.discord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      discord
      betterdiscordctl
      #betterdiscord-installer
    ];

    home.configFile = {
      "discord/settings.json".source = "${hey.configDir}/discord/settings.json";
    };
  };
}
