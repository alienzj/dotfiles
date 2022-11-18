{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.lockscreen;
in {
  options.modules.services.lockscreen = {
    enable = mkBoolOpt false;
    inactiveInterval = mkOption {
      type = types.int;
      default = 10;
    };
    arguments = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        betterlockscreen
      ];

      #services.screen-locker = {
      #  enable = true;
      #  inactiveInterval = cfg.inactiveInterval;
      #  lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock ${
      #    concatStringsSep " " cfg.arguments
      #  }";
      #};
    }
  ]);
}
