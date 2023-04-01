{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.logger.qjournalctl;
in {
  options.modules.desktop.logger.qjournalctl = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.qjournalctl
      ];
    }
  ]);
}
