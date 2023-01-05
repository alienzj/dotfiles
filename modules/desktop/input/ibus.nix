{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.input.ibus;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.input.ibus = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "ibus";
	ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
      };

      #home.configFile = {
      #  "ibus" = {
      #    source = "${configDir}/ibus";
      #	  recursive = true;
      #	};
      #};
    }
  ]);
}
