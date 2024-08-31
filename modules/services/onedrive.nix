# https://nixos.wiki/wiki/OneDrive
{
  hey,
  lib,
  options,
  config,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.onedrive;
in {
  options.modules.services.onedrive = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.onedrive.enable = true;
  };
}
