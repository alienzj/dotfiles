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
  cfg = devCfg.php;
in {
  options.modules.dev.php = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      php83
      php83Packages.composer
    ];
  };
}
