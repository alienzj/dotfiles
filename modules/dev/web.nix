{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  devCfg = config.modules.dev;
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
