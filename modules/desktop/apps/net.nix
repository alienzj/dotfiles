{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.net;
in {
  options.modules.desktop.apps.net = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # http/https proxy tool
      mitmproxy

      # REST client
      insomnia

      # network analyzer
      wireshark
    ];
  };
}
