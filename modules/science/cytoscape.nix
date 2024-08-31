{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.science.cytoscape;
in {
  options.modules.science.cytoscape = with types; {
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
