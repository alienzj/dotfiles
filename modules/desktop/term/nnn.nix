# modules/desktop/term/nnn.nix
#
# n³ The unorthodox terminal file manager
# https://github.com/nix-community/home-manager/blob/master/modules/programs/nnn.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.nnn;
in {
  options.modules.desktop.term.nnn = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [
      #nnn  # nnn + nice-to-have extensions

      (nnn.override { withIcons = true;})

      (makeDesktopItem {
        name = "nnn";
        desktopName = "n³ The unorthodox terminal file manager";
        genericName = "Default file manager";
        icon = "nnn";
        exec = "${nnn}/bin/nnn";
	terminal = true;
        keywords = [ "File" "Manager" "Management" "Explorer" "Launcher" ];
        categories = [ "System" "FileTools" "FileManager" "ConsoleOnly" ];
      })
 
    ];
  };
}
