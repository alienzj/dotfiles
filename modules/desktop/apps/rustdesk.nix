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
  cfg = config.modules.desktop.apps.rustdesk;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.rustdesk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      rustdesk
    ];
  };
}
