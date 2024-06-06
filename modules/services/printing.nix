# https://wiki.nixos.org/wiki/Printing
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.printing;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.printing = {
    enable = mkBoolOpt false;
    sharing = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.printing = {
        enable = true;
        #drivers = [ pkgs.epson-escpr ];
        #drivers = [
        #  (writeTextDir "share/cups/model/Ricoh/Ricoh-IM_C6000-PDF-Ricoh.ppd" (builtins.readFile "${configDir}/printer/Ricoh-IM_C6000-PDF-Ricoh.ppd"))
        #];
      };
    }

    (mkIf cfg.sharing {
      # Printer sharing
      services.avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
      services.printing = {
        listenAddresses = ["*:631"];
        allowFrom = ["all"];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
      };
    })
  ]);
}
