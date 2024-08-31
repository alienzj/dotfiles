{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  devCfg = config.modules.dev;
  cfg = devCfg.julia;
in {
  options.modules.dev.julia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      julia-lts
    ];
  };
}
