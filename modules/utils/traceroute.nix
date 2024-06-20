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
    exporterEnable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.mtr.enable = true;
    }

    # TODO
    ## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/mtr-exporter.nix
    (mkIf cfg.exporterEnable {
      services.mtr-exporter.enable = true;
    })
  ]);
}
