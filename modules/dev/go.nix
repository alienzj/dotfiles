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
  cfg = devCfg.go;
in {
  options.modules.dev.go = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      go
      gotools
      gopls
      gomodifytags
      gotests
      gore
    ];
  };
}
