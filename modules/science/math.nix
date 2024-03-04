{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.science.math;
in {
  options.modules.science.math = with types; {
    enable = mkBoolOpt false;
    tools.enable = mkBoolOpt true;
    worlframengine.enable = mkBoolOpt false;
    mathematica.enable = mkBoolOpt false;
    matlab.enable = mkBoolOpt false;
    cplex.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-matlab.overlay ];

    user.packages = with pkgs; 
      (if cfg.tools.enable then [
        unstable.wxmaxima
	unstable.geogebra
      ] else []) ++

      (if cfg.worlframengine.enable then [
	unstable.wolfram-engine
      ] else []) ++

      (if cfg.mathematica.enable then [
	(unstable.mathematica.override {
	  cudaSupport = false;
	  lang = "en";
	  webdoc = false;
	  version = "13.2.1";
	})
      ] else []) ++

      (if cfg.matlab.enable then [
        matlab-language-server
	matlab
	matlab-mlint
	matlab-mex
      ] else []) ++

      (if cfg.cplex.enable then [
	unstable.cplex
      ] else []);
  };
}
