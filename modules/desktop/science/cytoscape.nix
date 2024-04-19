{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.science.cytoscape;
in {
  options.modules.desktop.science.cytoscape = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.cytoscape
      ];
    }
  ]);
}
