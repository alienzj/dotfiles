# TODO
# Artificial intelligence
{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.science.ai;
in {
  options.modules.science.ai = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs.unstable; [
        ollama
        llama-cpp
        #lmstudio
        #aichat
        #chatgpt-cli
        #shell_gpt
        #chatblade
      ];
    }
  ]);
}
