{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.wezterm;
in {
  options.modules.desktop.term.wezterm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      wezterm
      #(makeDesktopItem {
      #  name = "wezterm";
      #  desktopName = "Wez Terminal";
      #  genericName = "Wez terminal";
      #  icon = "utilities-terminal";
      #  exec = "${xst}/bin/wezterm";
      #  categories = [ "Development" "System" "Utility" ];
      #})
    ];
  };
}
