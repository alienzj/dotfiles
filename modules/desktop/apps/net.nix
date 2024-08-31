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
  cfg = config.modules.desktop.apps.net;
in {
  options.modules.desktop.apps.net = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      # http/https proxy tool
      mitmproxy

      # REST client
      insomnia

      # network analyzer
      wireshark
    ];
  };
}
