{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.utils.neofetch;
    configDir = config.dotfiles.configDir;
in {
  options.modules.utils.neofetch = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.neofetch
    ];

    home.configFile = {
      "neofetch/config.conf".source = "${configDir}/neofetch/neofetch.conf";
    };
  }
}
