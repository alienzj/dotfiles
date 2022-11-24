{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.noter.notion;
in {
  options.modules.desktop.noter.notion = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.notion-app-enhanced
      ];
    }
  ]);
}
