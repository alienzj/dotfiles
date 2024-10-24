{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.rustdesk;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.rustdesk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      rustdesk
    ];
  };
}
