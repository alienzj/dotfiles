# reference
## https://wiki.nixos.org/wiki/Mtr
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.utils.traceroute;
in {
  options.modules.utils.traceroute = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.mtr.enable = true;
    services.mtr-exporter.enable = true;
  };
}
