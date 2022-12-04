{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.as;
in {
  options.modules.editors.as = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      android-tools
      android-file-transfer
      android-studio
    ];
  };
}
