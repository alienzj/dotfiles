{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.science.math;
in {
  options.modules.science.math = with types; {
    enable = mkBoolOpt false;
    tools.enable = mkBoolOpt true;
    worlframengine.enable = mkBoolOpt false;
    mathematica.enable = mkBoolOpt false;
    cplex.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; 
      (if cfg.tools.enable then [
        unstable.wxmaxima
	unstable.geogebra
      ] else []) ++

      (if cfg.worlframengine.enable then [
	unstable.wolfram-engine
      ] else []) ++

      (if cfg.mathematica.enable then [
        #mathematica
	(unstable.mathematica.override {
	  #source = pkgs.requireFile {
	  #  name = "Mathematica_13.2.1_LINUX.sh";
	  #  sha256 = "sha256:1661ra9c9lidswp9f2nps7iz9kq7fsgxd0x6kl7lv4d142fwkhdk";
	  #  message = ''
	  #    Hello, Mathematica!
	  #  '';
	  #  hashMode = "recursive";
	  #};
	  cudaSupport = false;
	  lang = "English";
	  webdoc = false;
	  version = "13.2.1";
	})
      ] else []) ++

      (if cfg.cplex.enable then [
	unstable.cplex
      ] else []);
  };
}
