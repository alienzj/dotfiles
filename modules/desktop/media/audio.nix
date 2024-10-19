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
  cfg = config.modules.desktop.media.audio;
in {
  options.modules.desktop.media.audio = with types; {
    enable = mkBoolOpt false;
    #tui.enable = mkBoolOpt false; # TODO
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sayonara
      netease-cloud-music-gtk
      lx-music-desktop
      (ncmpcpp.override {visualizerSupport = true;})
    ];


    environment.variables.NCMPCPP_HOME = "$XDG_CONFIG_HOME/ncmpcpp";

    # Symlink these one at a time because ncmpcpp writes other files to
    # ~/.config/ncmpcpp, so it needs to be writeable.
    home.configFile = {
      "ncmpcpp/config".source = "${hey.configDir}/ncmpcpp/config";
      "ncmpcpp/bindings".source = "${hey.configDir}/ncmpcpp/bindings";
    };
  };
}
