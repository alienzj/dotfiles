{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.science.ai;
in {
  options.modules.science.ai = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.aichat
        unstable.chatgpt-cli
	unstable.shell_gpt
	#unstable.chatblade
      ];
    }
  ]);
}
