# https://nixos.wiki/wiki/OneDrive

{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.onedrive;
in {
  options.modules.services.onedrive = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.onedrive.enable = true;
  };
}
