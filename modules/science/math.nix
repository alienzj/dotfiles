{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.science.math;
in {
  options.modules.science.math = with types; {
    enable = mkBoolOpt false;
    tools.enable = mkBoolOpt true;
    wolframengine.enable = mkBoolOpt false;
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

      (if cfg.wolframengine.enable then [
	unstable.wolfram-engine
        #(unstable.wolfram-engine.override {
        #  lang = "en";
	#  #version = "13.3.0";
	#  source = pkgs.requireFile {
        #    name = "WolframEngine_13.3.0_LINUX.sh";
	#    sha256 = "0fh3f2lcilank654milrc7d45l7sfq0ql4dyjzgqlv91p0q3n6q4";
	#    message = ''
        #      Your override for Wolfram Engine includes a different src for the installer,
        #      and it is missing.
	#    '';
	#    hashMode = "recursive";
	#  };
	#})

	unstable.wolfram-notebook
      ] else []) ++

      (if cfg.mathematica.enable then [
	(unstable.mathematica.override {
	  cudaSupport = false;
	  lang = "en";
	  webdoc = false;
	  version = "13.3.0";
          source = pkgs.requireFile {
            name = "Mathematica_13.3.0_BNDL_LINUX.sh";
            # Get this hash via a command similar to this:
            # nix-store --query --hash \
            # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
            # sha256 = "0000000000000000000000000000000000000000000000000000";
	    # sha256 = "1xl6ji8qg6bfz4z72b8czl0cx36fzfkxhygsn0m8xd0qgkkpjqfg";
	    sha256 = "0miwzw40bwh1fngj0nmhp7c02wjv80qwpzc8mlv0x3r9p61piwn7";
            message = ''
              Your override for Mathematica includes a different src for the installer,
              and it is missing.
            '';
            hashMode = "recursive";
	  };
	})
      ] else []) ++

      (if cfg.matlab.enable then [
	matlab
	matlab-mlint
	matlab-mex
      ] else []) ++
 
      (if cfg.cplex.enable then [
	unstable.cplex
      ] else []);
  };
}
