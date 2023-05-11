{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.vpn;
in {
  options.modules.desktop.apps.vpn = {
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
    ];
  };
}
