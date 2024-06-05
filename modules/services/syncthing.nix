{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.user.name;
      group = "users";
      configDir = "${config.user.home}/.config/syncthing";
      dataDir = "${config.user.home}/.local/share/syncthing";
      settings.folders = {};
    };

    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
