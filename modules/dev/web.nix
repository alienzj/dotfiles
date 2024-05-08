{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.web;
in {
  options.modules.dev.web = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
      user.packages = with pkgs; [
        html-tidy
	nodePackages.stylelint
	nodePackages.js-beautify
         
	# A fast static site generator with everything built-in
	zola
      ];
  };
}
