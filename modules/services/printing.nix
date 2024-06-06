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
  ]);
}
