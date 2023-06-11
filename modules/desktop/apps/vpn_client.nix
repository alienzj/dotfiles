{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.vpn_client;
in {
  options.modules.desktop.apps.vpn_client = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mullvad-vpn
      mozillavpn
      dsvpn
      tailscale
      headscale
      trayscale
      globalprotect-openconnect
    ];
  };
}
