{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.im.discord;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.im.discord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.discord
      unstable.betterdiscordctl
      #unstable.betterdiscord-installer
    ];

    home.configFile = {
      "discord/settings.json".source = "${configDir}/discord/settings.json";
    };
  };
}
