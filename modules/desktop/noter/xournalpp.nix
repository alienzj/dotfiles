{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.noter.xournalpp;
in {
  options.modules.desktop.noter.xournalpp = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.xournalpp
      ];
    }
  ]);
}
