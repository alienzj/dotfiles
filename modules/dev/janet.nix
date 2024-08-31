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
  cfg = devCfg.janet;
in {
  options.modules.dev.janet = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      janet
      jpm
    ];
  };
}
